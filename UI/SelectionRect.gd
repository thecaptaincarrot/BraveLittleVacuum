extends ColorRect

var fade = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade:
		if color.a > 0.05:
			color.a -= delta / 2 
		else:
			fade = false
	elif !fade:
		if color.a < 0.4:
			color.a += delta / 2
		else:
			fade = true
