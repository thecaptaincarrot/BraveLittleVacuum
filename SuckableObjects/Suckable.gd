extends RigidBody2D

const suckable = true
export var size = 0
export var identifier = "Default"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_DefaultSuckableObject_body_entered(body):
	if body.is_in_group("Enemy"):
		body.collision(self,linear_velocity)
		collision_layer = 8
		collision_mask = 1033
	elif body.is_in_group("World"):
		collision_mask = 1033


func _on_CollideTimer_timeout():
	collision_mask = 1033
