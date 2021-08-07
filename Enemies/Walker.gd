extends "res://Enemies/Enemy.gd"

enum {IDLE, ATTACK, DEAD, WALK}

enum DIRECTIONS {RIGHT,LEFT}

var walk_speed = 5
var max_speed = 30
var direction = DIRECTIONS.RIGHT

var player_for_hurting = null

export var asymetrical = false

# Called when the node enters the scene tree for the first time.
func _ready():
	state = IDLE #Is this necessesarily the case



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if asymetrical:
		match direction:
			DIRECTIONS.RIGHT:
				match state:
					IDLE:
						$Sprite.animation = "idleR"
					WALK:
						$Sprite.animation = "walkR"
					ATTACK:
						$Sprite.animation = "attackR"
					HURT:
						print("oof")
						$Sprite.animation = "hurtR"
					DEAD:
						$Sprite.animation = "dieR"
			DIRECTIONS.LEFT:
				match state:
					IDLE:
						$Sprite.animation = "idleL"
					WALK:
						$Sprite.animation = "walkL"
					ATTACK:
						$Sprite.animation = "attackL"
					HURT:
						print("oof")
						$Sprite.animation = "hurtL"
					DEAD:
						$Sprite.animation = "dieL"
	else:
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
	
	match state: #All actions are possible. AI is handled one floor down.
		IDLE:
			motion.x = 0
		WALK:
			if motion.length() < max_speed:
				motion += walk()
		ATTACK:
			motion.x = 0
		HURT:
			motion.x = 0
		DEAD:
			motion.x = 0
			
	
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
	collision_layer = 0


func _on_Sprite_animation_finished():
	if asymetrical:
		if $Sprite.animation == "dieL":
			$Sprite.animation = "deadL"
		elif $Sprite.animation == "dieR":
			$Sprite.animation = "deadR"
		elif $Sprite.animation == "attackR" or $Sprite.animation == "attackL":
			state = WALK
		
	else:
		if $Sprite.animation == "die":
			$Sprite.animation = "dead"
		elif $Sprite.animation == "attack":
			state = WALK
