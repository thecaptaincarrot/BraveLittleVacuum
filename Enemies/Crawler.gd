extends "res://Enemies/Enemy.gd"

enum {IDLE, WALK, HURT, DEAD, SEEKING,FIRING}

enum DIRECTIONS {RIGHT,LEFT}

var floor_direction = Vector2(0,1)
var walk_speed = 5
export var max_speed = 30
var direction = DIRECTIONS.RIGHT


# Called when the node enters the scene tree for the first time.
func _ready():
	state = IDLE
	
	if rotation_degrees > -45.0 and rotation_degrees < 45.0:
		floor_direction = Vector2(0,1)
	elif rotation_degrees < 135.0:
		floor_direction = Vector2(-1,0)
	elif rotation_degrees < 225.0:
		floor_direction = Vector2(0,-1)
	elif rotation_degrees < 315.0:
		floor_direction = Vector2(1,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match direction:
		DIRECTIONS.RIGHT:
			$AnimatedSprite.flip_h = false
		DIRECTIONS.LEFT:
			$AnimatedSprite.flip_h = true
	
	match state:
		IDLE:
			$AnimatedSprite.animation = "idle"
		WALK:
			$AnimatedSprite.animation = "walk"
		HURT:
			pass
		DEAD:
			$AnimatedSprite.animation = "die"


func _physics_process(delta):
	
	match state: #All actions are possible. AI is handled one floor down.
		IDLE:
			motion = Vector2(0,0)
		WALK:
			if motion.length() < max_speed:
				motion += walk()
		HURT:
			motion = Vector2(0,0)
	
	motion += floor_direction * Globals.GRAVITY * .1
	
	motion = move_and_slide(motion, floor_direction.rotated(PI))


func walk():
	#Move at speed left and right
	#apply sticky force towards flor
	#If reach end of platform or hit wall, switch directions.
	#Walk direction comes from sprite 
	var walk_vector = Vector2(0,0)
	match direction:
		DIRECTIONS.RIGHT:
			walk_vector = floor_direction.rotated(PI/2) * walk_speed
		DIRECTIONS.LEFT:
			walk_vector = floor_direction.rotated(-PI/2) * walk_speed
	return walk_vector


func _on_gap_detector_body_exited(body):
	motion = Vector2(0,0)
	if direction == DIRECTIONS.RIGHT:
		direction = DIRECTIONS.LEFT
	elif direction == DIRECTIONS.LEFT:
		direction = DIRECTIONS.RIGHT
