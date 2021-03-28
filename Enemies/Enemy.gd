extends KinematicBody2D

export var health = 1

var motion = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#I mean, it alwasy needs to be moving, rgiht???
	
	var collision = move_and_collide(motion)


