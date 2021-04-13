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
			pass


func _physics_process(delta):
	
	match state: #All actions are possible. AI is handled one floor down.
		IDLE:
			motion.x = 0
		WALK:
			if motion.length() < max_speed:
				motion += walk()
		HURT:
			motion.x = 0
		DEAD:
			motion.x = 0
			collision_layer = 0
			
	
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
	print(walk_vector)
	return walk_vector
		


func die():
	$Sprite.animation = "die"
	state = DEAD


func _on_Sprite_animation_finished():
	if $Sprite.animation == "die":
		$Sprite.animation = "dead"
