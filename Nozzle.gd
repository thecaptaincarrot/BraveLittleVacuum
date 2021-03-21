extends KinematicBody2D

const Objects = preload("res://SuckableObjects.gd")

var returning = false
var anchor
var force = 300

var limit = 150
var collision_limit = 175

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
	
	var target = Vector2()
	
	if (global_position - anchor.global_position).length() > collision_limit:
		target = (anchor.global_position - global_position).normalized()
	elif (global_position - anchor.global_position).length() > limit and (global_mouse - anchor.global_position).length() > limit:
		target = vector_projection(global_position - anchor.global_position)
	elif local_mouse.length() > 5:
		target = (global_mouse - global_position).normalized() #Normal Moement
	
	if (global_position - anchor.global_position).length() > collision_limit:
		emit_signal("uncollide_hose")
		collision_layer = 0
		collision_mask = 0
	else:
		emit_signal("collide_hose")
		collision_layer = 20
		collision_mask = 20
	
	move_and_slide(target * force,Vector2(0,-1),false,4,.78, false)
	if !(Input.is_action_pressed("suck") or Input.is_action_pressed("blow")):
		rotation += (local_mouse.angle() + PI/2) * 0.2


func vector_projection(origin_vector):
	var theta = origin_vector.angle()
	var unit = origin_vector.normalized()
	var mouse_vector = (global_mouse - global_position).normalized() #from nozzle to mouse position
	
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


func shoot(body):
	print(Objects)
	var new_rock = SuckableObjects.rock
	emit_signal("shoot",new_rock, global_position, rotation)


func _on_Area2D_body_entered(body):
	suckables.append(body)


func _on_Area2D_body_exited(body):
	suckables.erase(body)


func _on_NozzleHole_body_entered(body):
	if Input.is_action_pressed("suck") and body.get("suckable"):
		emit_signal("sucked",body)
		body.queue_free()
