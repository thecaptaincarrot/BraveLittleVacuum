extends Node2D

const WATER = preload("res://LiquidParticle.tscn")

var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("blow"):
		var new_drop = WATER.instance()
		new_drop.position = get_global_mouse_position()
		add_child(new_drop)
		i += 1
		print(i)
