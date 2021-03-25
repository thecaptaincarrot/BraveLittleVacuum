extends StaticBody2D

var target_segment


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_segment != null:
		$Line2D.points[1] = target_segment.position

