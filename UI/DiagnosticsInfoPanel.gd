extends NinePatchRect

var i = 0
var text = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func clear():
	$MarginContainer/VBoxContainer/InfoBubble.text = ""


func _on_bubble_timeout():
	if $MarginContainer/VBoxContainer/InfoBubble.text != text:
		$MarginContainer/VBoxContainer/InfoBubble.text += text[i]
		i += 1
		
