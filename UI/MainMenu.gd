extends Control

signal animation_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func open():
	$AnimationPlayer.play("MenuOpen")


func close():
	$AnimationPlayer.play("MenuClose")


func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.
