extends RigidBody2D

var previous_segment = self
var next_segment = self
var force = 1
export var size = 4

var i = 0

var collision_limit

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	$CollisionShape2D.shape.radius = size
	collision_limit = (size + 2 ) * 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	if global_position.distance_to(previous_segment.global_position) > collision_limit:
		collision_mask = 0
	elif global_position.distance_to(next_segment.global_position) > collision_limit:
		collision_mask = 0
	else:
		collision_mask = 1
