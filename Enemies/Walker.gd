extends "res://Enemies/Enemy.gd"

enum {IDLE, WALK, HURT, DEAD}

enum DIRECTIONS {RIGHT,LEFT}

var walk_speed = 5
var max_speed = 30
var direction = DIRECTIONS.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	state = IDLE #Is this necessesarily the case


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match direction:
		DIRECTIONS.RIGHT:
			$Sprite.flip_h = false
		DIRECTIONS.LEFT:
			$Sprite.flip_h = true
	
	match state:
		IDLE:
			$Sprite.animation = "idle"
		WALK:
			$Sprite.animation = "walk"
		HURT:
			$Sprite.animation = "hurt"
		DEAD:
			$Sprite.animation = "die"


func _physics_process(delta):
	
	match state: #All actions are 
		IDLE:
			motion.x = 0
		WALK:
			if motion.length() < max_speed:
				motion += walk()
		HURT:
			motion.x = 0
	
	print("Enemy Motion: ", motion)
	if is_on_floor():
		motion.y += Globals.GRAVITY * 0.2
	else:
		motion.y += Globals.GRAVITY
	
	motion = move_and_slide(motion, Vector2(0,-1))


func walk():
	#Move at speed in direction of slope
	#If collide with wall, turn around
	#Walk direction comes from sprite 
	var horizontal_vector = get_floor_normal().rotated(PI/2)
	var walk_vector = Vector2(0,0)
	match direction:
		DIRECTIONS.RIGHT:
			walk_vector = horizontal_vector * walk_speed
		DIRECTIONS.LEFT:
			walk_vector = -horizontal_vector * walk_speed
	return walk_vector
		


func die():
	state = DEAD
