extends KinematicBody2D

var returning = false
var anchor
var force = 300

var limit = 150
var collision_limit = 200

var local_mouse
var global_mouse

var suckables = []
var suck_strength = 5

signal uncollide_hose
signal collide_hose

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	pass
	if Input.is_action_pressed("suck"):
		$Area2D/Polygon2D.show()
		suck()
	elif Input.is_action_pressed("blow"):
		$Area2D/Polygon2D.show()
		blow()
	else:
		$Area2D/Polygon2D.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	local_mouse = get_local_mouse_position()
	global_mouse = get_global_mouse_position()
	
	var target = Vector2()
	
	if (global_position - anchor.global_position).length() > limit:
		target = (anchor.global_position - global_position).normalized()
		
	elif local_mouse.length() > 5 and (global_mouse - anchor.global_position).length() < limit:
		target = (global_mouse - global_position).normalized()
	elif local_mouse.length() > 5:
		target = vector_projection(global_position - anchor.global_position)
	
	if (global_position - anchor.global_position).length() > collision_limit:
		emit_signal("uncollide_hose")
		collision_layer = 0
		collision_mask = 0
	else:
		emit_signal("collide_hose")
		collision_layer = 20
		collision_mask = 20
	
	
	move_and_slide(target * force,Vector2(0,-1),false,4,.78, false)
	if !Input.is_mouse_button_pressed(BUTTON_LEFT):
		rotation += (local_mouse.angle() + PI/2) * 0.2


func vector_projection(origin_vector):
	var theta = origin_vector.angle()
	var unit = origin_vector.normalized()
	var mouse_vector = (global_mouse - global_position).normalized() #from nozzle to mouse position
	
	var projection = (mouse_vector.dot(origin_vector)/origin_vector.dot(origin_vector)) * origin_vector
	
	var rejection = mouse_vector - projection
	return rejection


func suck():
	$Area2D/Polygon2D.show()
	for object in suckables:
		object.apply_central_impulse((global_position - object.global_position).normalized() * suck_strength)


func blow():
	$Area2D/Polygon2D.show()
	for object in suckables:
		object.apply_central_impulse((object.global_position - global_position).normalized() * suck_strength)

func _on_Area2D_body_entered(body):
	suckables.append(body)
	print("suckable found")


func _on_Area2D_body_exited(body):
	suckables.erase(body)
