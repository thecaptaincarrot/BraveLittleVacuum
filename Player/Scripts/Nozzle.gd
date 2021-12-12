extends KinematicBody2D

const WATER = preload("res://Player/WaterAnimator.tscn")

var player_body = null 
var inactive = false
var hose_segment =  null

var returning = false
var anchor
var force = 1
var mouse_scalar = 1.6

var true_limit = 100
var limit = 100
var collision_limit = 105

var mouse_vector = Vector2(0,0)
var movement_vector = Vector2(0,0)
var direction = 0

var drag = .1
var angular_drag = .3

var local_mouse
var global_mouse

var suckables = []
var stuck_object = null

var water_source = null
var is_in_liquid = false

var pivot_point = Vector2(0,0)
var pivoting = false
var pivotlength = 0

signal uncollide_hose
signal collide_hose
signal sucked
signal liquid_sucked
signal shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	pivot_point = anchor.position
	$Suck/Polygon2D.polygon = $Suck/CollisionPolygon2D.polygon
	limit = true_limit
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
	
	var orthogonal_mode = false
	
	#First, check movement
	var target = Vector2()
	
	if (position - anchor.position).length() > collision_limit: #Snapback
		returning = true
	elif position.distance_to(pivot_point) > limit and\
	 (vector_projection(position - pivot_point)).length() > limit + 5 and\
	vector_projection(position - pivot_point).normalized() + (position - pivot_point).normalized() != Vector2(0,0): #Orthogonal
		returning = false
		target = vector_rejection(position - pivot_point)
		orthogonal_mode = true
	else: #Normal Movement
		returning = false
		target = movement_vector #Normal Moement
	
	if returning:
		target = (pivot_point - position)
		target.x = target.x * 2
		target.y = target.y * 2
#		emit_signal("uncollide_hose")
		collision_layer = 0
		collision_mask = 0
	else:
#		emit_signal("collide_hose")
		collision_layer = 2
		collision_mask = 3
	
	move_and_slide(target,Vector2(0,-1),false,4,.78, false)
	
	#Drag on movement vector when mouse is not moving
	movement_vector.x = lerp(movement_vector.x,0,drag)
	movement_vector.y = lerp(movement_vector.y,0,drag)
	
	if !((Input.is_action_pressed("suck") or Input.is_action_pressed("blow")) and !stuck_object):
		var to_angle = movement_vector.angle() + PI/2
		if to_angle > PI:
			to_angle -= 2 * PI #Could just fix this by changing the sprite
		if movement_vector.length() > 30.0:
			rotation = to_angle
		else:
			#fix snap around
			if rotation > PI/2 and to_angle < -PI/2: #PI/2 clockwise
				to_angle += 2 * PI
			if rotation < -PI/2 and to_angle > PI/2: #PI/2 clockwise
				to_angle -= 2 * PI
			
			rotation = lerp(rotation,to_angle,movement_vector.length()/400.0)
	
	if stuck_object:
		var stuck_position = global_position
		stuck_object.stick(stuck_position, rotation)
		if $StuckObjectCollisionShape.shape == null:
			$StuckObjectCollisionShape.shape = stuck_object.get_node("CollisionShape2D").shape
			$StuckObjectCollisionShape.rotation = stuck_object.get_node("CollisionShape2D").rotation
			$StuckObjectCollisionShape.position = stuck_object.get_suck_position() + Vector2(0,-3)


func _input(event):
	if inactive:
		return
	
	if event is InputEventMouseMotion:
		mouse_vector = event.relative
		movement_vector += event.relative * mouse_scalar
	
	if event.is_action_released("suck"):
		if stuck_object and $StuckObjectTimer.is_stopped():
			$StuckObjectTimer.start()
		for object in suckables:
			object.custom_integrator = false
			object.captured = false
	elif event.is_action_pressed("blow"):
		pass


func vector_projection(origin_vector): #Projects the movement vector onto the position of the nozzle
	var theta = origin_vector.angle()
	var unit = origin_vector
	
	var projection = (movement_vector.dot(origin_vector)/origin_vector.dot(origin_vector)) * origin_vector
	return projection


func vector_rejection(origin_vector):
	var theta = origin_vector.angle()
	var unit = origin_vector
	
	var projection = (movement_vector.dot(origin_vector)/origin_vector.dot(origin_vector)) * origin_vector
	
	var rejection = movement_vector - projection
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
	if !stuck_object:
		$Suck/Polygon2D.show()
		for object in suckables:
			object.capture_point = global_position
			if !object.captured:
				object.custom_integrator = true
				object.captured = true
				object.relative_position = object.global_position - global_position
#			object.apply_central_impulse((global_position - object.global_position).normalized() * Upgrades.suck_strength)
#			if object.is_in_group("Suckables"):
#				object.gravity_scale = 0
#			else:
#				object.gravity_scale = 0.5
	else:
		if !$StuckObjectTimer.is_stopped():
			$StuckObjectTimer.stop()


func blow():
	if stuck_object:
		$StuckObjectTimer.stop()
		stuck_object.unstick()
		var force_impulse = Upgrades.blow_force * Vector2(0,-1).rotated(rotation)
		stuck_object.apply_central_impulse(force_impulse)
		stuck_object.apply_torque_impulse(rand_range(-200,200))
		stuck_object.damaging = true
		stuck_object = null
		$StuckObjectCollisionShape.shape = null


func _on_Suck_body_entered(body):
	if body.is_in_group("Bodies"):
		body.can_sleep = false
		body.sleeping = false
		
		suckables.append(body)
		print(suckables)


func _on_Suck_body_exited(body):
	suckables.erase(body)
	if body.is_in_group("Bodies"):
		body.can_sleep = true
		body.custom_integrator = false
		body.captured = false


func _on_NozzleHole_body_entered(body):
	if Input.is_action_pressed("suck") and !stuck_object:
		if body.is_in_group("Suckables"):
			body.custom_integrator = false
			body.captured = false
			emit_signal("sucked",body)
		if body.is_in_group("Large"):
			stuck_object = body


func _on_StuckObjectTimer_timeout():
	stuck_object.unstick()
	stuck_object = null
	$StuckObjectCollisionShape.shape = null
