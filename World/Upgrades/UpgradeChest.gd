extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func activate(): #Generic activate function. Can do anything
	print("I have been activated")
	$ChestSprite.play("Open")
	$MainCollision.disabled = true


func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("Player"):
		activate()


func _on_CollissionDetectionZone_body_entered(body):
	print(body)
	if body.is_in_group("Bodies"):
		activate()


func _on_ChestSprite_animation_finished():
	if $ChestSprite.animation == "Open":
		$UpgradeSphere.active = true
