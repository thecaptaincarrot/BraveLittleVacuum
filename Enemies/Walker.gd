extends "res://Enemies/Enemy.gd"
#this is a basic scene for anything affected by gravity
enum {IDLE, ATTACK, DEAD, WALK, HURT}

enum DIRECTIONS {RIGHT,LEFT}

var walk_speed = 5
var max_speed = 30
var direction = DIRECTIONS.RIGHT

var player_for_hurting = null

export var asymetrical = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(delta):
	pass

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
	collision_layer = 0
