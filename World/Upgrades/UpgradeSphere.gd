extends AnimatedSprite
var upgrade_type = "DEFAULT"
var active = false
var collectable = false

var t = 0
var t_offset = 8

var start_position
var default_position

var player_in = false

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
			position.y = lerp(position.y, -26, .02)
		else:
			collectable = true
	
	
	if player_in and active:
		emit_signal("upgrade_collected",upgrade_type)

		collectable = false
		active = false
		hide()

func _on_CollectionArea_body_entered(body):
	if body.is_in_group("Player"):
		player_in = true


func _on_CollectionArea_body_exited(body):
	if body.is_in_group("Player"):
		player_in = false
