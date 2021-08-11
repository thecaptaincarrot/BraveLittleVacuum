extends ColorRect

var fade = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade:
		if color.a > 0.05:
			color.a -= 2 * delta / 3
		else:
			fade = false
	elif !fade:
		if color.a < 0.3:
			color.a += 2 * delta / 3
		else:
			fade = true
