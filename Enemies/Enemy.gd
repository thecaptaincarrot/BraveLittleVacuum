extends KinematicBody2D

enum {DEFAULT}

export var health = 1

var motion = Vector2(0,0)
var state = DEFAULT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#moving and sliding is done deeper
	pass


func collision(body,collision_speed):
	print(body)
	if body.damaging:
		print("Ouch")
		var damage = 1
		hurt(damage)
		print("new_health: ", health)
		if health <= 0:
			die()


func die():
	pass
	

func hurt(damage):
	health -= damage
