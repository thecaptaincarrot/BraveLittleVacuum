extends KinematicBody2D

var returning = false
var anchor
var force = 1

var limit = 100
var collision_limit = 130

var movement_vector = Vector2(0,0)
var direction = 0

var drag = .08
var angular_drag = .3

var local_mouse
var global_mouse

var suckables = []
var suck_strength = 5

signal uncollide_hose
signal collide_hose
signal sucked
signal shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	pass
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
		
		target = (anchor.global_position - global_position)
		target.x = target.x * 2
		target.y = target.y * 2
	elif (global_position - anchor.global_position).length() > limit and (global_position + movement_vector - anchor.global_position).length() > limit: #Orthogonal
		target = vector_projection(global_position - anchor.global_position)
	elif local_mouse.length() > 5: #Normal Movement
		target = movement_vector #Normal Moement
	
	if (global_position - anchor.global_position).length() > collision_limit:
		emit_signal("uncollide_hose")
		collision_layer = 0
		collision_mask = 0
	else:
		emit_signal("collide_hose")
		collision_layer = 16
		collision_mask = 16
	
	move_and_slide(target,Vector2(0,-1),false,4,.78, false)
	
	movement_vector.x = lerp(movement_vector.x,0,drag)
	movement_vector.y = lerp(movement_vector.y,0,drag)
	
	if !(Input.is_action_pressed("suck") or Input.is_action_pressed("blow")):
		var to_angle = movement_vector.angle() + PI/2
		if to_angle > PI:
			to_angle -= 2 * PI #Could just fix this by changing the sprite
		rotation = lerp(rotation,to_angle,angular_drag)


func _input(event):
	if event is InputEventMouseMotion:
		movement_vector += event.relative


func vector_projection(origin_vector):
	var theta = origin_vector.angle()
	var unit = origin_vector
	var mouse_vector = movement_vector #from nozzle to mouse position
	
	var projection = (mouse_vector.dot(origin_vector)/origin_vector.dot(origin_vector)) * origin_vector
	
	var rejection = mouse_vector - projection
	return rejection


func suck():
	$Suck/Polygon2D.show()
	for object in suckables:
		object.apply_central_impulse((global_position - object.global_position).normalized() * suck_strength)


func blow():
	$Suck/Polygon2D.show()
	for object in suckables:
		object.apply_central_impulse((object.global_position - global_position).normalized() * suck_strength)


func _on_Area2D_body_entered(body):
	suckables.append(body)


func _on_Area2D_body_exited(body):
	suckables.erase(body)


func _on_NozzleHole_body_entered(body):
	if Input.is_action_pressed("suck") and body.get("suckable"):
		emit_signal("sucked",body)
