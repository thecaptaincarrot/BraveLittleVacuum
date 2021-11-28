extends Node2D

const HOSE = preload("res://Player/Hose.tscn")
const NOZZLE = preload("res://Player/Nozzle.tscn")

onready var body = $PlayerBody

export var main_path = ""
var main
var camera

var hose_segments = []
var hose_positions = []

var motion = Vector2(0,0)

var hose_size = 0
var nozzle
var update_line = false

var gravity = 9.8
var inertia = 100
var hurt_damage_vector = Vector2(200,-200)

var enemies_in_hitbox = []

var health = 100.0
var max_health = 100.0
var invulnerable = false

var is_in_water = false
var input_disabled = false

signal shoot

var test


# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_node(main_path)
	camera = $PlayerBody/PlayerCamera
	create_hose_skeleton(Upgrades.hose_length)
	$CanvasLayer/Tank.connect("shoot",main,"nozzle_shoot")
	$CanvasLayer/Tank.connect("liquidshoot",main,"liquid_nozzle_shoot")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_line = true


func _process(delta):
	if is_in_water and !Upgrades.waterproof:
		health -= 10.0 * delta #10 is a placeholder
	if !enemies_in_hitbox.empty():
		hurt(enemies_in_hitbox[0].collision_damage)
		pass
	update_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if update_line:
		update_line()


func _input(event):
	pass
	if event is InputEventKey and event.scancode == KEY_PAGEUP:
		Upgrades.hose_length += 1
		regenerate_hose(Upgrades.hose_length)
	if event is InputEventKey and event.scancode == KEY_PAGEDOWN:
		Upgrades.hose_length -= 1
		regenerate_hose(Upgrades.hose_length)


func hurt(damage):
	if invulnerable: return
	health -= damage
	$PlayerBody/PlayerSprite/PlayerScreen.hurt()
	if $PlayerBody/PlayerSprite.flip_h:
		$PlayerBody.motion = hurt_damage_vector
	else:
		var new_vector = Vector2(-hurt_damage_vector.x, hurt_damage_vector.y)
		$PlayerBody.motion = new_vector
	input_disabled = true
	invulnerable = true
	$iFrameTimer.start()
	$PlayerBody/InputEater.start()


func update_health():
	var health_percentage = health/max_health
	$CanvasLayer/HealthBar.value = health


func deactivate():
	invulnerable = true
	input_disabled = true
	
	nozzle.set_process(false)
	nozzle.set_physics_process(false)
	nozzle.set_process_input(false)


func queue_activate():
	yield(get_tree().create_timer(0.5),"timeout")
	activate()


func activate():
	invulnerable = false
	$PlayerBody.force_move = false
	input_disabled = false
	
	nozzle.set_process(true)
	nozzle.set_physics_process(true)
	nozzle.set_process_input(true)


func place_body(new_position):
	get_hose_relative_positions()
	$PlayerBody.position = new_position
#	nozzle.position = Vector2(0,-64)
	reset_hose_position()


#HOSE STUFF
func create_hose_skeleton(length):
	var parent = $PlayerBody/Hose/HoseStart
	var child

	hose_segments.clear()
	hose_segments.append(parent)
	child = add_hose(parent)
	add_anchor_pin(parent,child)
	hose_segments.append(child)
	parent = child
	
	for i in range (Upgrades.hose_length):
		child = add_hose(parent)
		add_pin(parent,child)
		hose_segments.append(child)
		parent = child
	
	child = add_nozzle(parent)
	nozzle = child
	add_pin_nozzle(parent,child)
	
	for base_hose in hose_segments:
		base_hose.set_process(true)
		for hose in hose_segments:
			base_hose.add_collision_exception_with(hose)
	
	nozzle.set_physics_process(true)


func remove_hose():
	nozzle.set_physics_process(false)
	for hose in hose_segments:
		hose.set_process(false)
	
	camera.nozzle = null
	nozzle.queue_free()
	nozzle = null

	for hose in hose_segments:
		if hose != $PlayerBody/Hose/HoseStart:
			hose.queue_free()
	
	hose_segments = []


func regenerate_hose(length):
	update_line = false
	var previous_nozzle_pos = nozzle.position
	remove_hose()
	create_hose_skeleton(length)
	nozzle.position = previous_nozzle_pos
	update_line = true


func add_hose(parent):
	var new_hose = HOSE.instance()
	hose_size = new_hose.size
	new_hose.position = parent.position
	new_hose.position.y -= 2 * hose_size
	
	new_hose.previous_segment = parent
	if parent.name != "HoseStart":
		parent.next_segment = new_hose
	
	$PlayerBody/Hose.add_child(new_hose)
	return new_hose


func add_nozzle(parent):
	var new_nozzle = NOZZLE.instance()
	new_nozzle.position = parent.position
	
	new_nozzle.anchor = $PlayerBody/Hose/HoseStart
	
	new_nozzle.connect("sucked", $CanvasLayer/Tank, "add_suckable")
	new_nozzle.connect("liquid_sucked", $CanvasLayer/Tank, "add_liquid")
	
	new_nozzle.true_limit = (hose_size + 1) * Upgrades.hose_length * 2
	new_nozzle.collision_limit = new_nozzle.limit + 5
	
	main.nozzle = new_nozzle #fix this to be the Main variable, as it were
	camera.nozzle = new_nozzle
	new_nozzle.player_body = $PlayerBody
	new_nozzle.hose_segment = parent
	
	new_nozzle.add_collision_exception_with($PlayerBody)
	
	$PlayerBody/Hose.add_child(new_nozzle)
	return new_nozzle


func get_hose_relative_positions():
	hose_positions.clear()
	for hose in hose_segments:
		hose_positions.append(hose.position)

func reset_hose_position():
	var i = 0
	for hose in hose_segments:
		if hose.name != "HoseStart":
			hose.reset_position(hose_positions[i] + body.global_position)
			i += 1


func add_anchor_pin(parent,child):
	var pin = PinJoint2D.new()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	pin.softness = 0.05
	pin.bias = .9
	pin.disable_collision = true
	parent.add_child(pin)


func add_pin(parent,child):
	var pin = PinJoint2D.new()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	pin.softness = 0.05
	pin.bias = .1
	pin.disable_collision = true
	parent.add_child(pin)


func add_pin_nozzle(parent,child):
	var pin = PinJoint2D.new()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	pin.softness = 0.05
	pin.bias = 0.0
	pin.disable_collision = true
	parent.add_child(pin)


func update_line():
	var i = 0
	
	var line = $PlayerBody/Hose/Line2D
	
	if len(hose_segments) >= len(line.points):
		line.clear_points()
		line.add_point(Vector2(0,0))
		for j in range(len(hose_segments)):
			line.add_point(Vector2(0,0))
			pass
	
	line.points[i] = Vector2(0,0)
	i += 1
	
	for hose in hose_segments:
		if hose != null:
			line.points[i] = hose.position
			i += 1


func check_hose_length():
	var length = 0
	var start_position = hose_segments[0].position
	for N in hose_segments:
		length += start_position.distance_to(N.position)
		start_position = N.position
	
	return length


func collide_hose():
	for N in hose_segments:
		N.collision_layer = 0
		N.collision_mask = 1
	

func uncollide_hose():
	for N in hose_segments:
		N.collision_layer = 0
		N.collision_mask = 0

#Menu stuff
func hide_UI():
	for child in $CanvasLayer.get_children():
		child.hide()


func show_UI():
	for child in $CanvasLayer.get_children():
		child.show()


#SIGNALS
func _on_HitBox_area_entered(area):
	if area.is_in_group("Water"):
		is_in_water = true


func _on_HitBox_area_exited(area):
	if area.is_in_group("Water") and is_in_water:
		is_in_water = false


func _on_HitBox_body_entered(body):
	if body.is_in_group("Enemy"):
		enemies_in_hitbox.append(body)


func _on_HitBox_body_exited(body):
	if enemies_in_hitbox.has(body):
		enemies_in_hitbox.erase(body)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "MenuClose":
		show_UI()


func _on_InputEater_timeout():
	input_disabled = false


func _on_iFrameTimer_timeout():
	invulnerable = false
