extends NinePatchRect

var expand_speed = 300
var complete = false

var text

signal menu_unpause

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Pop out
	#needs to figure out low long $Label is and expand just as much as it needs to. 
	var x_position = 256
	var y_position = 252
	
	var size_x = 320
	var size_y = 72
	#just measure position
	if rect_position.y > y_position:
		rect_position.y -= delta * expand_speed / 6
		rect_size.y += delta * expand_speed * 2 / 6
	else:
		if rect_position.x > x_position:
			rect_position.x -= delta * expand_speed
			rect_size.x += delta * expand_speed * 2
		else:
			$Label.show()
			complete = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and complete:
		emit_signal("menu_unpause")
		queue_free()

