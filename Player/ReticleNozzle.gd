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

var motion = Vector2(0,0)

signal sucked


# Called when the node enters the scene tree for the first time.
func _ready():
	limit = Upgrades.hose_length * 10.0 #10.0 is the size of the joints. Should probably be taken from a single source of truth
	
	bounding_box_limits = sqrt((limit ^2) / 2)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	if reticle:
		#Face towards Reticle
		var camera_position = camera.get_camera_screen_center ()
		var relative_position =  global_position - camera_position
		
		print(relative_position)
		
		var global_mouse = get_global_mouse_position()
		var camera_mouse = global_mouse - camera_position # need to remove offset?
		var relative_mouse = global_mouse - camera_position - relative_position
		
		rotation = relative_mouse.angle()
		
		#move in box, use motion and not absolute transforms
#		var x_coordinate = bounding_box_limits * 



















