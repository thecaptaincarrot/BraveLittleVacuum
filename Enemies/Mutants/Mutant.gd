extends "res://Enemies/Walker.gd"
#THIS IS AN AI SCRIPT
#IF IT'S A NEW BEHAVIOR, PUT IT ONE LEVEL UP

export (DIRECTIONS) var initial_direction = DIRECTIONS.LEFT

var can_see_player = false
var can_attack_player = false

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = initial_direction
	walk_speed =30
	max_speed = 30


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Animations and actions
	match direction:
		DIRECTIONS.RIGHT:
			match state:
				IDLE:
					motion.x = 0
					$Sprite.animation = "idleR"
				WALK:
					$Sprite.animation = "walkR"
					if motion.length() < max_speed:
						motion += walk()
				ATTACK:
					motion.x = 0
					$Sprite.animation = "attackR"
					if $AttackWinddown.is_stopped():
						$AttackWinddown.start()
				HURT:
					motion.x = 0
					$Sprite.animation = "hurtR"
				DEAD:
					motion.x = 0
					$Sprite.animation = "dieR"
		DIRECTIONS.LEFT:
			match state:
				IDLE:
					motion.x = 0
					$Sprite.animation = "idleL"
				WALK:
					$Sprite.animation = "walkL"
					if motion.length() < max_speed:
						motion += walk()
				ATTACK:
					motion.x = 0
					$Sprite.animation = "attackL"
					if $AttackWinddown.is_stopped():
						$AttackWinddown.start()
				HURT:
					motion.x = 0
					$Sprite.animation = "hurtL"
				DEAD:
					motion.x = 0
					$Sprite.animation = "dieL"
	#AI Flowchart
	match state:
		IDLE:
			if can_attack_player:
				state = ATTACK
			elif can_see_player:
				state = WALK
		WALK:
			if can_attack_player:
				state = ATTACK
			elif can_see_player:
				if !$WalkTimer.is_stopped():
					$WalkTimer.stop()
			else:
				if $WalkTimer.is_stopped():
					$WalkTimer.start()
		ATTACK:
			pass
		HURT:
			pass
	#
	match direction: #Detection Facing
		DIRECTIONS.RIGHT:
			$Sprite/Hitboxes.scale.x = -1.0
		DIRECTIONS.LEFT:
			$Sprite/Hitboxes.scale.x = 1.0


func hurt(damage):
	print("Ouch")
	if state != ATTACK:
		state = HURT
	health -= damage


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("Player"):
		can_see_player = true


func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("Player"):
		can_see_player = false


func _on_WalkTimer_timeout():
	if state == WALK:
		state = IDLE


func _on_AttackDetector_body_entered(body):
	if body.is_in_group("Player"):
		can_attack_player = true


func _on_AttackDetector_body_exited(body):
	if body.is_in_group("Player"):
		can_attack_player = false


func _on_AttackWinddown_timeout():
	if state == ATTACK:
		if can_attack_player:
			$Sprite.frame = 0
			state = ATTACK
		elif can_see_player:
			state = WALK
		else:
			if $WalkTimer.is_stopped():
				$WalkTimer.start()
				state = WALK


func _on_Sprite_animation_finished():
	if state == HURT:
		if can_attack_player:
			state = ATTACK
		elif can_see_player:
			state = WALK
		else:
			if direction == DIRECTIONS.RIGHT and Globals.PLAYER.body.position.x <= position.x:
				direction = DIRECTIONS.LEFT
				$WalkTimer.start()
				state = WALK
			elif direction == DIRECTIONS.LEFT and Globals.PLAYER.body.position.x >= position.x:
				direction = DIRECTIONS.RIGHT
				$WalkTimer.start()
				state = WALK
			else:
				$WalkTimer.start()
				state = WALK
