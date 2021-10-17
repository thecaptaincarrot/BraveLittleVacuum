extends RigidBody2D

const suckable = true
export var size = 0
export var identifier = "Default"
var damaging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(collision_layer)
	print(collision_mask)



func _on_DefaultSuckableObject_body_entered(body):
	if body.is_in_group("Enemy"):
		body.collision(self,linear_velocity)
		collision_layer = 8
		damaging = false
	elif body.is_in_group("World"):
		collision_layer = 8
		damaging = false

func _on_CollideTimer_timeout():
	collision_mask = 8
