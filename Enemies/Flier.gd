extends "res://Enemies/Enemy.gd"

enum {IDLE, FLY, DEAD, HURT}

export var fly_acceleration = .5
export var max_speed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion = move_and_slide(motion, Vector2(0,-1))


func fly_towards(destination : Vector2):
	var fly_vector = Vector2(0,0)
	
	var direction_vector = (destination - position).normalized()
	fly_vector = direction_vector * fly_acceleration
	
	return fly_vector
