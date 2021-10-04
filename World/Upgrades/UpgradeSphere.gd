extends AnimatedSprite

export var ugrade_type = "DEFAULT"
var active = false
var collectable = false

var t = 0
var t_offset = 8

var start_position
var default_position

signal upgrade_collected

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collectable:
		position.y = -24 + t_offset * sin(t * 2)
		t += delta
	elif active:
		if position.y > -24:
			position.y -= delta * 24
		else:
			collectable = true


func _on_CollectionArea_body_entered(body):
	if body.is_in_group("Player") and collectable:
		print("Yo, found and upgrade: ",ugrade_type)
		emit_signal("upgrade_collected",ugrade_type)
		body.motion = Vector2(0,0)
		
		collectable = false
		active = false
		hide()
