extends "res://Enemies/Enemy.gd"

enum {IDLE, WALK, HURT, DEAD}

enum DIRECTIONS {RIGHT,LEFT}

var walk_speed = 100
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
	motion.y += Globals.GRAVITY
	match state: #All actions are 
		IDLE:
			motion.x = 0
		WALK:
			motion += walk()
		HURT:
			motion.x = 0
	
	motion = move_and_slide(motion)


func walk():
	#Move at speed in direction of slope
	#If collide with wall, turn around
	#Walk direction comes from sprite 
	var horizontal_vector = get_floor_normal().rotated(PI/2)
	var walk_vector = Vector2(0,0)
	match direction:
		DIRECTIONS.RIGHT:
			walk_vector += horizontal_vector
		DIRECTIONS.LEFT:
			walk_vector -= horizontal_vector
	
	return walk_vector
		


func die():
	state = DEAD
