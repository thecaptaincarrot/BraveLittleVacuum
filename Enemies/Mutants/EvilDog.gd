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
			$Sprite.animation = "dead"
	
	#Animations
	match state:
		IDLE:
			$Sprite.animation = "Idle"
		WALK:
			if is_on_floor():
				$Sprite.animaion = "walk"
			else:
				if motion.y < 0:
					$Sprite.animaion = "attack"
				else:
					$Sprite.animation = "land"


func _on_WallDetector_body_entered(body):
	print(body)
	motion = Vector2(0,0)
	if direction == DIRECTIONS.RIGHT:
		print("Right")
		direction = DIRECTIONS.LEFT
		print(direction)
	elif direction == DIRECTIONS.LEFT:
		print("Left")
		direction = DIRECTIONS.RIGHT
		print(direction)


func hurt(damage):
	health -= damage


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("Player") and state == IDLE:
		state = WALK
		#Move in the direction of player too I guess
