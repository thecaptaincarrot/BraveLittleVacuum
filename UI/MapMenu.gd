extends Control

signal previous
signal next

var active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _unhandled_input(event):
	if !visible:
		return
	if event.is_action_pressed("ui_cancel"):
		pass #exit menu
