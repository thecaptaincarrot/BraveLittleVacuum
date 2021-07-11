tool
extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FileDialog_dir_selected(dir):
	pass # Replace with function body.


func _on_LevelCreateDialogue_about_to_show():
	$VBoxContainer/GridPosition/X.value = 1
	$VBoxContainer/GridPosition/Y.value = 1
	
	$FileDialog.popup()
