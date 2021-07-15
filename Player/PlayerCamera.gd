extends Camera2D

var nozzle = null
var nozzle_reduction = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if nozzle != null:
		offset.y = nozzle.position.y / nozzle_reduction
		offset.x = nozzle.position.x / nozzle_reduction
	else:
		offset = Vector2(0,0)
