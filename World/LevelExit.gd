tool
extends Area2D

export var level_code = Vector2(0,0)
export var target_exit = 0

signal level_exit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LevelExit_body_entered(body):
	if body.is_in_group("Player") and Engine.editor_hint:
		print("Emitting Signal")
		emit_signal("level_exit",level_code,target_exit)
