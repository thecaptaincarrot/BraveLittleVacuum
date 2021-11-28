extends Skeleton2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bone_count = get_bone_count()
	
	for i in bone_count:
		var bone = get_bone(i)
		var bone_angle = bone.get_true_rotation()
		print(bone.name, " rotation: ", bone_angle)
		var gravity_acceleration = 1.0
		var bone_length = 16.0 #Can this be calculated from game state
		var tip_acceleration = cos(bone_angle)*gravity_acceleration/bone_length
		bone.angular_velocity += tip_acceleration * delta
