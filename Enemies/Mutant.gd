extends "res://Enemies/Walker.gd"
#THIS IS AN AI SCRIPT
#IF IT'S A NEW BEHAVIOR, PUT IT ONE LEVEL UP

export (DIRECTIONS) var initial_direction = DIRECTIONS.LEFT


# Called when the node enters the scene tree for the first time.
func _ready():
	direction = initial_direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
