extends KinematicBody2D

const WATER = preload("res://Player/WaterAnimator.tscn")

var player_body = null 
var inactive = false

var returning = false
var anchor
var force = 1

var limit = 100
var collision_limit = 130

var movement_vector = Vector2(0,0)
var direction = 0

var drag = .1
var angular_drag = .3

var local_mouse
var global_mouse

var suckables = []

var water_source = null
var is_in_liquid = false

signal uncollide_hose
signal collide_hose
signal sucked
signal liquid_sucked
signal shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	$Suck/Polygon2D.polygon = $Suck/CollisionPolygon2D.polygon
	collision_limit = limit + 5
	set_physics_process(false)


func _process(delta):
	if Input.is_action_pressed("suck"):
		$Suck/Polygon2D.show()
		suck()
	elif Input.is_action_pressed("blow"):
		$Suck/Polygon2D.show()
		blow()
	else:
		$Suck/Polygon2D.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	local_mouse = get_local_mouse_position()
	global_mouse = get_global_mouse_position()
	
	#First, check movement
	var target = Vector2()
	
	if (global_position - anchor.global_position).length() > collision_limit: #Snapback
		returning = true
	elif (global_position - anchor.global_position).length() > limit and (global_position + movement_vector - anchor.global_position).length() > collision_limit: #Orthogonal
		returning = false
		target = vector_projection(global_position - anchor.global_position)
	else: #Normal Movement
		returning = false
		target = movement_vector #Normal Moement
	
	if returning:
		target = (anchor.global_position - global_position)
		target.x = target.x * 2
		target.y = target.y * 2
#		emit_signal("uncollide_hose")
		collision_layer = 0
		collision_mask = 0
	else:
#		emit_signal("collide_hose")
		collision_layer = 2
		collision_mask = 2

	
	move_and_slide(target,Vector2(0,-1),false,4,.78, false)
	
	movement_vector.x = lerp(movement_vector.x,0,drag)
	movement_vector.y = lerp(movement_vector.y,0,drag)
	
	if !(Input.is_action_pressed("suck") or Input.is_action_pressed("blow")):
		var to_angle = movement_vector.angle() + PI/2
		if to_angle > PI:
			to_angle -= 2 * PI #Could just fix this by changing the sprite
		if movement_vector.length() > 50.0:
			rotation = to_angle
		else:
			rotation = lerp(rotation,to_angle,movement_vector.length()/400.0)


func _input(event):
	if inactive:
		return
	
	if event is InputEventMouseMotion:
		movement_vector += event.relative
		
	if event.is_action_released("suck"):
		for object in suckables:
			object.gravity_scale = 1


func vector_projection(origin_vector):
	var theta = origin_vector.angle()
	var unit = origin_vector
	var mouse_vector = movement_vector #from nozzle to mouse position
	
	var projection = (mouse_vector.dot(origin_vector)/origin_vector.dot(origin_vector)) * origin_vector
	
	var rejection = mouse_vector - projection
	return rejection


func get_midpoint(vector_array):
	var x = 0
	var y = 0
	for vector in vector_array:
		x += vector.x
		y += vector.y
	
	x = x / len(vector_array)
	y = y / len(vector_array)

	return Vector2(x,y)


func suck():
	$Suck/Polygon2D.show()

#	if water_source != null and !is_in_liquid:
#		var position_arr = []
#		for cast in $RayCasts.get_children():
#			if cast.is_colliding():
#				var local_position = cast.get_collision_point()
#				position_arr.append(local_position)
#		if position_arr != [] and $LiquidSpawn.is_stopped(): 
#			var new_pos = get_midpoint(position_arr)
#			var new_water = WATER.instance()
#			new_water.position = new_pos
#			new_water.connect("freed",self,"water_freed")
#			get_node("/root/RobotTest/Clutter").add_child(new_water)
#			$LiquidSpawn.start()
		
	
	for object in suckables:
		object.apply_central_impulse((global_position - object.global_position).normalized() * Upgrades.suck_strength)
		object.gravity_scale = 0

func blow():
	pass


func water_freed(water):
	suckables.erase(water)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Bodies"):
		suckables.append(body)


func _on_Area2D_body_exited(body):
	suckables.erase(body)
	if body.is_in_group("Bodies"):
		body.gravity_scale = 1


func _on_NozzleHole_body_entered(body):
	if Input.is_action_pressed("suck"):
		if body.is_in_group("Bodies"):
			emit_signal("sucked",body)
#		if body.is_in_group("Liquid"):
#			emit_signal("liquid_sucked",body)


func _on_Suck_area_entered(area):
	pass
#	if area.is_in_group("Water"):
#		water_source = area


func _on_Suck_area_exited(area):
	pass
#	if area == water_source: #This is going to cause weird behaviors
#		water_source = null


func _on_NozzleHole_area_entered(area):
	pass
#	if area.is_in_group("Water"):
#		print("entered Liquid")
#		is_in_liquid = true


func _on_NozzleHole_area_exited(area):
	pass
#	if area.is_in_group("Water"):
#		print("Exitted liquid")
#		is_in_liquid = false
