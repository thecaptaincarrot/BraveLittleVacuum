extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	custom_integrator = true # Replace with function body.
	add_force(Vector2(0,0),Vector2(0,9.8))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _integrate_forces(state):
	state.add_central_force(Vector2(0,9.8))
