extends "res://Enemies/Walker.gd"

export (String, "RunningL","RunningR","Idle") var default_state

# Called when the node enters the scene tree for the first time.
func _ready():
	walk_speed = 80
	max_speed = 80
	match default_state:
		"Idle":
			print("Idle")
			state = IDLE
		"RunningR":
			print("Running")
			state = WALK
			direction = DIRECTIONS.RIGHT
		"RunningL":
			print("Running")
			state = WALK
			direction = DIRECTIONS.LEFT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		IDLE:
			motion.x = 0
		WALK:
			print("running")
			if motion.length() < max_speed:
				motion += walk()
			
			if is_on_wall():
				if direction == DIRECTIONS.RIGHT:
					direction = DIRECTIONS.LEFT
				elif direction == DIRECTIONS.LEFT:
					direction = DIRECTIONS.RIGHT
					

