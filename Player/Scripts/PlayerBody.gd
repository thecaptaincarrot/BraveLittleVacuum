extends KinematicBody2D

var motion = Vector2()

var gravity = 9.8
var acceleration = 5
var inertia = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion.y += gravity
	
	if Input.is_action_pressed("move_left"):
		motion.x -= acceleration
		if motion.x > 5:
			motion.x -= acceleration
	if Input.is_action_pressed("move_right"):
		motion.x += acceleration
		if motion.x < 5:
			motion.x += acceleration
	else:
		motion.x = lerp(motion.x,0,.05)
	
#	move_and_slide(motion,Vector2(0,0),false,4,4/PI,true)
	move_and_collide(motion)
	
#	for index in get_slide_count():
#		var collision = get_slide_collision(index)
#		if collision.collider.is_in_group("Bodies"):
#			collision.collider.apply_central_impulse(-collision.normal * inertia)
