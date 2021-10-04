extends ColorRect

var fadeout = false
var multiplier = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fadeout and color.a <1.0:
		color.a += delta * multiplier
	elif !fadeout and color.a > 0.0:
		color.a -= delta * multiplier
