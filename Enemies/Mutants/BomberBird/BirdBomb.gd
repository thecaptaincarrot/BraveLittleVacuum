extends "res://Enemies/Flier.gd"

var player_body = null
export var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	state = FLY #I don't think it'll ever have a different state
	if Globals.PLAYER != null:
		player_body = Globals.PLAYER.body


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#AI
	match state:
		FLY:
			if player_body != null:
				motion += fly_towards(player_body.position)
				if motion.length() > max_speed:
					motion = motion.normalized() * max_speed
		DEAD:
			motion = Vector2(0,0)
			$Collider.disabled = true
			
	#Animation
	match state:
		FLY:
			$Sprite.animation = "Fly"
		DEAD:
			$Sprite.animation = "Die"


func die():
	state = DEAD


func _on_PlayerCollisionDetector_body_entered(body):
	if body.is_in_group("Player") and state != DEAD:
		Globals.PLAYER.hurt(damage)
		state = DEAD


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Die":
		queue_free()
