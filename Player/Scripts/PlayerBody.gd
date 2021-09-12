extends KinematicBody2D

var motion = Vector2()

var inactive = false
var force_move = false
var exiting = false

var force_move_vector = Vector2(0,0)

var gravity = 9.8
var acceleration = 4
var skid_friction = 1.0

var neutral_drag = 0.01

var max_speed = 200
var inertia = 100

var downhill = false
var can_hover = true
var is_hovering = false

var jump_impulse = 340

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	if inactive: 
		return
		
	if is_on_floor() and (!can_hover or $HoverTimer.time_left < $HoverTimer.wait_time):
		can_hover = true
		$HoverTimer.paused = false
		$HoverTimer.stop()
	
	if motion.x > 10:
		$PlayerSprite.flip_h = false
		$PlayerSprite/PlayerScreen.flip_h = false
	elif motion.x < -10:
		$PlayerSprite.flip_h = true
		$PlayerSprite/PlayerScreen.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if inactive: return
	if force_move:
		if force_move_vector.y == 0:
			motion.x = force_move_vector.x
			motion.y += Globals.GRAVITY
		else:
			motion = force_move_vector
		motion = move_and_slide(motion,Vector2(0,-1)) #Up vector never changes?
	else:
		movement(delta)
	
	var floor_normal = Vector2(0,-1)
	var angle = 0
	
	
	if $GroundNormal.is_colliding():
		floor_normal = $GroundNormal.get_collision_normal()
	
	angle = floor_normal.angle() + PI/2
	
	if is_on_floor():
		$PlayerSprite.rotation = lerp($PlayerSprite.rotation,angle,.10)
	else:
		$PlayerSprite.rotation = lerp($PlayerSprite.rotation,0,.10)
#	rotation = lerp(rotation,angle,.25)
	
#	for index in get_slide_count():
#		var collision = get_slide_collision(index)
#		if collision.collider.is_in_group("Bodies"):
#			print("By Golly that was a collision")
#			collision.collider.apply_central_impulse(-collision.normal * inertia)


func movement(delta):
	if !$InputDelay.is_stopped():
		return
	
	if !is_hovering:
		if !is_on_floor():
			motion.y += gravity
		else:
			motion.y += gravity / 5
	else:
		motion.y = 0
	
	if get_parent().input_disabled:
		motion = move_and_slide(motion,Vector2(0,-1)) #Up vector never changes?
		return
		
	
	#"""Horizontal""" movement
	var horizontal_vector = Vector2(1,0)
	if is_on_floor():
		horizontal_vector = get_floor_normal().rotated(PI/2)
		
	if Input.is_action_pressed("move_right"):
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
		if is_hovering:
			is_hovering = false
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
	if Input.is_action_just_pressed("Jump") and is_on_floor() and Upgrades.jump:
		$JumpSound.play()
		motion.y = 0
		motion.y -= jump_impulse
		
	
	#Hover
	if is_on_floor():
		is_hovering = false

	if !is_on_floor() and can_hover and Input.is_action_just_pressed("Jump"):
		is_hovering = true
		can_hover = false
		if $HoverTimer.is_stopped():
			$HoverTimer.start()
		else:
			$HoverTimer.paused = false
	if is_hovering and !Input.is_action_pressed("Jump"):
		is_hovering = false
		if !$HoverTimer.is_stopped():
			can_hover = true
		$HoverTimer.paused = true
	
	motion = move_and_slide(motion,Vector2(0,-1)) #Up vector never changes?


func menu_unpause():
	$InputDelay.start()


func _on_HoverTimer_timeout():
	is_hovering = false
