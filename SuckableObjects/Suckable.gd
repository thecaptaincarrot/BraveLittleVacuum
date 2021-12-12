extends RigidBody2D

const suckable = true
export var size = 0.0
export var identifier = "Default"
var damaging = false

var captured = false
var capture_point = Vector2(0,0)
var force_move

var relative_position : Vector2

var suck_velocity = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if captured:
		relative_position = relative_position - relative_position.normalized() * 250.0 * delta


func _integrate_forces(state):
	if captured:
		state.transform = Transform2D(rotation, relative_position + capture_point)


func _on_DefaultSuckableObject_body_entered(body):
	if body.is_in_group("Enemy"):
		body.collision(self,linear_velocity)
		damaging = false
		gravity_scale = 1.0
		collision_mask = 8
	elif body.is_in_group("World"):
		collision_mask = 8
		gravity_scale = 1.0
		damaging = false


func to_tank():
	collision_layer = 32
	collision_mask = 32


func start_timer():
	$GravityTimer.call_deferred("start")


func _on_GravityTimer_timeout():
	print("ding)")
	gravity_scale = 1.0
