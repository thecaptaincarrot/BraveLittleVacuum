extends "res://World/Levels/LevelBase.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("I am where I should be")
	if Upgrades.jump:
		print("goodbye road")
		$World/CollapsingBridge.queue_free()
	else:
		for enemy in $Enemies.get_children():
			enemy.queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
