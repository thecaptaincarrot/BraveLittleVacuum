extends KinematicBody2D


var motion = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	motion = get_global_mouse_position() - global_position
	
	move_and_slide(motion, Vector2(0,-1),4,4/PI,false)
