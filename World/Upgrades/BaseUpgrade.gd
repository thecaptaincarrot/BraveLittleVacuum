extends AnimatedSprite

export var ugrade_type = "DEFAULT"
var active = true

signal upgrade_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	$HINTTEXT.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CollectionArea_body_entered(body):
	if body.is_in_group("Player") and active:
		print("Yo, found and upgrade")
		emit_signal("upgrade_collected",ugrade_type)
