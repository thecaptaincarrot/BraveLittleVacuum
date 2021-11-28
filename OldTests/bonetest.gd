extends Bone2D

var angular_velocity = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if name == "Bone2D4":
		position = get_global_mouse_position()
#	rotate(angular_velocity)
#	angular_velocity = lerp(angular_velocity,0,.01)
#	if rotation >= 2 * PI:
#		rotation = 0
#	elif rotation <= -2 * PI:
#		rotation = 0

func get_true_rotation():
	if get_parent().name == "HoseSkeletonTest":
		return rotation
	return rotation + get_parent().get_true_rotation()
