extends AudioStreamPlayer

onready var power_up = preload("res://Player/Sounds/vacuum_power_up.wav")
onready var power_down = preload("res://Player/Sounds/vacuum_power_down.wav")
onready var loop = preload("res://Player/Sounds/vacuum_loopable_body.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event.is_action_pressed("blow") or event.is_action_pressed("suck"):
		stream = power_up
		play()
	elif event.is_action_released("blow") or event.is_action_released("suck"):
		if stream != power_up:
			stream = power_down
			play()
		else:
			var playback = get_playback_position()
			if playback > 0.4:
				stream = power_down
				play()
			else:
				stream = null


func _on_AudioStreamPlayer_finished():
	if stream == power_up:
		stream = loop
		play()
