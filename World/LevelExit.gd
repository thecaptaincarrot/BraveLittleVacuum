tool
extends Area2D

export var level_code = 0
export var target_exit = 0

var mouse_in = false

signal level_exit

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.show()
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		if $Node2D/Destination.text != str(level_code):
			$Node2D/Destination.text = str(level_code)
			


func _on_LevelExit_body_entered(body):
	if body.is_in_group("Player"):
		print("Emitting Signal")
		emit_signal("level_exit",level_code,target_exit)
