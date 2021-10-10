extends StaticBody2D

export var upgrade_type = "DEFAULT"
signal upgrade_collected

var active = true

onready var LID = preload("res://SuckableObjects/ChestLid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$UpgradeSphere.upgrade_type = upgrade_type
	$HintText.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func activate(): #Generic activate function. Can do anything
	print("I have been activated")
	active = false
	$ChestSprite.play("Open")


func check_upgrade():
	match upgrade_type:
		"JUMP":
			if Upgrades.jump:
				active = false
				$ChestSprite.play("Done")
				$MainCollision.set_deferred("disabled",true)
				$OpenCollision.set_deferred("disabled",false)


func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("Player"):
		activate()


func _on_CollissionDetectionZone_body_entered(body):
	print(body)
	if body.is_in_group("Bodies") and active:
		activate()


func _on_ChestSprite_animation_finished():
	if $ChestSprite.animation == "Open":
		
		$MainCollision.set_deferred("disabled",true)
		$OpenCollision.set_deferred("disabled",false)
		
		var new_lid = LID.instance()
		new_lid.position = Vector2(0,-3)
		add_child(new_lid)
		new_lid.apply_central_impulse(Vector2(-100,-400))
		$UpgradeSphere.active = true


func _on_UpgradeSphere_upgrade_collected(type):
	emit_signal("upgrade_collected",upgrade_type)
