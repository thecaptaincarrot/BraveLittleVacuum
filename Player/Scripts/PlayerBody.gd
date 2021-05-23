extends KinematicBody2D

var motion = Vector2()

var gravity = 9.8
var acceleration = 4
var skid_friction = 1.0

var neutral_drag = 0.01

var max_speed = 200
var inertia = 100

var downhill = false

var jump_impulse = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	if motion.x > 10:
		$PlayerSprite.flip_h = false
		$PlayerSprite/PlayerScreen.flip_h = false
	elif motion.x < -10:
		$PlayerSprite.flip_h = true
		$PlayerSprite/PlayerScreen.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	movement(delta)
	
	var floor_normal = Vector2(0,-1)
	var angle = 0
	
	
	if $GroundNormal.is_colliding():
		floor_normal = $GroundNormal.get_collision_normal()
	
	angle = floor_normal.angle() + PI/2
	
	$PlayerSprite.rotation = lerp($PlayerSprite.rotation,angle,.10)
#	rotation = lerp(rotation,angle,.25)
	
#	for index in get_slide_count():
#		var collision = get_slide_collision(index)
#		if collision.collider.is_in_group("Bodies"):
#			print("By Golly that was a collision")
#			collision.collider.apply_central_impulse(-collision.normal * inertia)


func movement(delta):
	if !is_on_floor():
		motion.y += gravity
	else:
		motion.y += gravity / 5
	
	#"""Horizontal""" movement
	var horizontal_vector = Vector2(1,0)
	if is_on_floor():
		horizontal_vector = get_floor_normal().rotated(PI/2)
		
	if Input.is_action_pressed("move_right"):
		print("moving")
		if motion.x < 0:
			motion += horizontal_vector * (acceleration + acceleration * skid_friction)
		else:
			motion += horizontal_vector * acceleration
	elif Input.is_action_pressed("move_left"):
		if motion.x > 0:
			motion -= horizontal_vector * (acceleration + acceleration * skid_friction)
		else:
			motion -= horizontal_vector * (acceleration)
	
	elif is_on_floor():
		motion.x = lerp(motion.x, 0,(max_speed / motion.length()) * neutral_drag)
	
	#Clamp
	if (motion.length() > max_speed and motion.y <= 10) and is_on_floor(): #can fall faster than normal
		motion.x = motion.normalized().x * max_speed
		motion.y = motion.normalized().y * max_speed
	elif !is_on_floor() and motion.x > max_speed:
		motion.x = max_speed
	elif !is_on_floor() and motion.x < -max_speed:
		motion.x = -max_speed
	#Jumping
	#need to check whether jumping has been unlocked globally
	if Input.is_action_pressed("Jump") and is_on_floor():
		print("JUMP")
		motion.y -= jump_impulse
	
	motion = move_and_slide(motion,Vector2(0,-1)) #Up vector never changes?
