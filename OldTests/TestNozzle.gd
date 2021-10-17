extends KinematicBody2D

var movement_vector = Vector2(0,0)
var direction = 0

var drag = .08
var angular_drag = .3

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(movement_vector)
	

	
	var to_angle = movement_vector.angle() + PI/2
	
	if to_angle > PI:
		to_angle -= 2 * PI
	
	rotation = lerp(rotation,to_angle,angular_drag)

func _input(event):
	if event is InputEventMouseMotion:
		movement_vector += event.relative
