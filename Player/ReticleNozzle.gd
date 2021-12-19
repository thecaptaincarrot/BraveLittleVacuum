extends KinematicBody2D

var reticle
var player_body
var hose_segment
var camera

var stuck_object

var anchor = null
var true_limit = 0
var collision_limit = 0
var limit = 50

var bounding_box_limits
var screensize

var motion = Vector2(0,0)

signal sucked


# Called when the node enters the scene tree for the first time.
func _ready():
#	limit = Upgrades.hose_length * 10.0 #10.0 is the size of the joints. Should probably be taken from a single source of truth
	limit = 6.0 * 10.0 #10.0 is the size of the joints. Should probably be taken from a single source of truth
	
	bounding_box_limits = sqrt((pow(limit, 2.0)) / 2.0)
	screensize = get_viewport().size 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	if reticle:
		#Get relatives
		var camera_position = camera.get_camera_screen_center ()
		var relative_position =  global_position - camera_position
		
		var global_mouse = get_global_mouse_position()
		var camera_mouse = global_mouse - camera_position # need to remove offset?
		var relative_mouse = global_mouse - camera_position - relative_position
		
		#Cast checker to reticle
		$TargetRay.cast_to = relative_mouse
		$TargetRay.rotation = -rotation
		#Face towards Reticle
		rotation = relative_mouse.angle()
		
		#move in box, use motion and not absolute transforms
		var x_coordinate = (4 * camera_mouse.x / screensize.x) 
		var y_coordinate = (4 * camera_mouse.y / screensize.y) 
		
		var rest_position = Vector2(0,-30)
		var target_position = Vector2(x_coordinate * bounding_box_limits, y_coordinate * bounding_box_limits) + rest_position
		
		var motion = (target_position - position) * 5.0
		
		print(target_position)
		
		move_and_slide(motion,Vector2(0,-1),false,4,.78, false)



















