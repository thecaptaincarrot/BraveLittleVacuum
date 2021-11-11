extends "res://Enemies/Walker.gd"

export (String, "RunningL","RunningR","Idle") var default_state

# Called when the node enters the scene tree for the first time.
func _ready():
	walk_speed = 80
	max_speed = 160
	match default_state:
		"Idle":
			print("Idle")
			state = IDLE
		"RunningR":
			print("Running")
			state = WALK
			direction = DIRECTIONS.RIGHT
		"RunningL":
			print("Running L ")
			state = WALK
			direction = DIRECTIONS.LEFT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match direction:
		DIRECTIONS.RIGHT:
			$Sprite.flip_h = true
			$Hitboxes.scale.x = -1.0
		DIRECTIONS.LEFT:
			$Sprite.flip_h = false
			$Hitboxes.scale.x = 1.0
	
	#Behavior and AI
	match state:
		IDLE:
			motion.x = 0
		WALK:
			if motion.length() < max_speed:
				motion += walk()
				print(motion)
			else:
				if is_on_floor():
					motion = motion.clamped(max_speed)
		DEAD:
			collision_layer = 0
			collision_mask = 1
			motion.x = 0
			$Sprite.animation = "Dead"
	
	#Animations
	match state:
		IDLE:
			$Sprite.animation = "Idle"
		WALK:
			$Sprite.animation = "Walk"
#			else:
#				if motion.y < 3:
#					$Sprite.animation = "Attack"
#				else:
#					$Sprite.animation = "Land"


func _on_WallDetector_body_entered(body):
	motion = Vector2(0,0)
	if direction == DIRECTIONS.RIGHT:
		direction = DIRECTIONS.LEFT
	elif direction == DIRECTIONS.LEFT:
		direction = DIRECTIONS.RIGHT


func hurt(damage):
	health -= damage


func die():
	state = DEAD
	collision_layer = 0
	modulate = Color.darkgray


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("Player") and state == IDLE:
		state = LOOKING
		$Sprite.play("LookL")
		#Move in the direction of player too I guess


func _on_Sprite_animation_finished():
	if $Sprite.animation == "LookL":
		state = WALK
	elif $Sprite.animation == "LookR":
		if direction == DIRECTIONS.RIGHT:
			direction = DIRECTIONS.LEFT
		elif direction == DIRECTIONS.LEFT:
			direction = DIRECTIONS.RIGHT
		state = WALK


func _on_PlayerDetectorBehind_body_entered(body):
	if body.is_in_group("Player") and state == IDLE:
		state = LOOKING
		$Sprite.play("LookR")
		#Move in the direction of player too I guess

