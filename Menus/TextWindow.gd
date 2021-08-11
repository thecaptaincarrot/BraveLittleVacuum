tool
extends NinePatchRect

export var text = "Ding Dong"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $MarginContainer/Label.text != text:
		$MarginContainer/Label.text = text
