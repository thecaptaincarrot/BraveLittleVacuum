extends RigidBody2D

var stuck_position = Vector2(0,0)
var stuck_rotation = 0.0

var stuck = false
var unstick = false
var damaging = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _integrate_forces(state):
	if stuck:
		state.transform = Transform2D(stuck_rotation, stuck_position)
		if unstick:
			stuck = false
			unstick = false


func stick(nozzle_position, nozzle_rotation):
	stuck_rotation = nozzle_rotation + PI
	stuck_position = nozzle_position - ($SuckPosition.position).rotated(stuck_rotation)
	
	stuck = true
	
	position = stuck_position
	rotation = stuck_rotation
	

func unstick():
	set_linear_velocity(Vector2(0,0))
	set_angular_velocity(0)
	position = stuck_position
	rotation = stuck_rotation
	unstick = true


func get_suck_position():
	return $SuckPosition.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DefaultLargeObject_body_entered(body):
	if body.is_in_group("Enemy"):
		body.collision(self,linear_velocity)
		damaging = false
	elif body.is_in_group("World"):
		damaging = false
