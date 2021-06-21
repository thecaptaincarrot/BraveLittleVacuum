extends AudioStreamPlayer

onready var end = preload("res://Player/Sounds/vacuum_hover_end.wav")
onready var loop = preload("res://Player/Sounds/vacuum_hover_loop.wav")

var looping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().body.is_hovering and playing == false:
		stream = loop
		play()
		looping = true
	elif !get_parent().body.is_hovering and looping == true:
		stream = end
		play()
		looping = false
