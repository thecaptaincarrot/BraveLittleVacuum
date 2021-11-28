extends RigidBody2D

var anchor = null

var player_body = null

var stuck_object = null

func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	if mode == MODE_KINEMATIC:
		position = get_global_mouse_position()


func _integrate_forces(state):
	pass



func _input(event):
	if event.is_action_pressed("blow"):
		if mode == MODE_KINEMATIC:
			mode = MODE_RIGID
		else:
			mode = MODE_KINEMATIC
