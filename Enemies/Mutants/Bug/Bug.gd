extends "res://Enemies/Flier.gd"

var player_body = null

var PIECES = preload("res://Enemies/Mutants/Bug/BugPieces.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#AI
	match state:
		IDLE:
			motion = Vector2(0,0)
		FLY:
			if player_body != null:
				motion += fly_towards(player_body.position)
				if motion.length() > max_speed:
					motion = motion.normalized() * max_speed
	#Animation
	match state:
		IDLE:
			$Sprite.animation = "Idle"
		FLY:
			$Sprite.animation = "Fly"
			if motion.x < 0:
				$Sprite.flip_h = true
			else:
				$Sprite.flip_h = false


func die():
	state = DEAD
	var new_pieces = PIECES.instance()
	new_pieces.position = position
	get_parent().call_deferred("add_child",new_pieces)
	queue_free()


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("Player"):
		player_body = body
		state = FLY
