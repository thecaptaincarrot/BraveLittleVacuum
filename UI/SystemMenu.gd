extends Control

var selection = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		$SelectionSprite.position.y = 144 + 48 * selection


func _unhandled_input(event):
	if !visible:
		return
	if event.is_action_pressed("ui_up"):
		if selection == 0:
			selection = 2
		else:
			selection -= 1
	elif event.is_action_pressed("ui_down"):
		if selection == 2:
			selection = 0
		else:
			selection += 1
