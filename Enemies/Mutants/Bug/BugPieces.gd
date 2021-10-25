extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Head.apply_central_impulse(Vector2(100,-100))
	$Body.apply_central_impulse(Vector2(-100,-100))
	$Wing.apply_central_impulse(Vector2(-100,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
