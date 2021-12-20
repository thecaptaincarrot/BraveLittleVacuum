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
var inactive = false

var suckables = []

signal sucked


# Called when the node enters the scene tree for the first time.
func _ready():
#	limit = Upgrades.hose_length * 10.0 #10.0 is the size of the joints. Should probably be taken from a single source of truth
	limit = 6.0 * 10.0 #10.0 is the size of the joints. Should probably be taken from a single source of truth
	
	bounding_box_limits = sqrt((pow(limit, 2.0)) / 2.0)
	screensize = get_viewport().size 
	
	$Suck/Polygon2D.polygon = $Suck/CollisionPolygon2D.polygon
	$Suck/Polygon2D.transform = $Suck/CollisionPolygon2D.transform


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("suck"):
		$Suck/Polygon2D.show()
		suck()
	elif Input.is_action_pressed("blow"):
		blow()
	else:
		$Suck/Polygon2D.hide()


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
		$TargetRay/DownCast.cast_to = relative_mouse
		$TargetRay/UpCast.cast_to = relative_mouse
		$TargetRay.rotation = -rotation
		#Face towards Reticle
		rotation = relative_mouse.angle()
		
		#move in box, use motion and not absolute transforms
		var x_coordinate = (4 * camera_mouse.x / screensize.x) 
		var y_coordinate = (4 * camera_mouse.y / screensize.y) 
		
		var rest_position = Vector2(0,-30)
		var target_position = Vector2(x_coordinate * bounding_box_limits, y_coordinate * bounding_box_limits) + rest_position
		
		#check if target is obscured
		if $TargetRay.is_colliding():
			$TargetRay/DownCast.enabled = true
			$TargetRay/UpCast.enabled = true
			if $TargetRay/DownCast.is_colliding() and !$TargetRay/DownCast.is_colliding():
				target_position.y -= 5.0
				print("move_up")
			elif !$TargetRay/DownCast.is_colliding() and $TargetRay/DownCast.is_colliding():
				print("move_down")
				target_position.y += 5.0
		else:
			$TargetRay/DownCast.enabled = false
			$TargetRay/UpCast.enabled = false
			
		var motion = (target_position - position) * 5.0
		move_and_slide(motion,Vector2(0,-1),false,4,.78, false)
	#Stuck objects
	if stuck_object:
		var stuck_position = global_position
		stuck_object.stick(stuck_position, rotation)
		if $StuckObjectCollisionShape.shape == null:
			$StuckObjectCollisionShape.shape = stuck_object.get_node("CollisionShape2D").shape
			$StuckObjectCollisionShape.rotation = stuck_object.get_node("CollisionShape2D").rotation
			$StuckObjectCollisionShape.position = stuck_object.get_suck_position() + Vector2(0,-3)


func _input(event):
	if inactive:
		return
	
	if event.is_action_released("suck"):
		if stuck_object and $StuckObjectTimer.is_stopped():
			$StuckObjectTimer.start()
		for object in suckables:
			if object.is_in_group("Suckables"):
				object.custom_integrator = false
				object.captured = false
	elif event.is_action_pressed("blow"):
		pass


func suck():
	if !stuck_object:
		$Suck/Polygon2D.show()
		for object in suckables:
			object.capture_point = global_position
			if !object.captured:
				if object.is_in_group("Suckables"):
					object.custom_integrator = true
					object.captured = true
					object.relative_position = object.global_position - global_position
				else:
					object.apply_central_impulse((global_position - object.global_position).normalized() * Upgrades.suck_strength)
					object.gravity_scale = 0.5
#			object.apply_central_impulse((global_position - object.global_position).normalized() * Upgrades.suck_strength)
#			if object.is_in_group("Suckables"):
#				object.gravity_scale = 0
#			else:
#				object.gravity_scale = 0.5
	else:
		if !$StuckObjectTimer.is_stopped():
			$StuckObjectTimer.stop()


func blow():
	if stuck_object:
		$StuckObjectTimer.stop()
		stuck_object.unstick()
		var force_impulse = Upgrades.blow_force * Vector2(1,0).rotated(rotation)
		stuck_object.apply_central_impulse(force_impulse)
		stuck_object.apply_torque_impulse(rand_range(-200,200))
		stuck_object.damaging = true
		stuck_object = null
		$StuckObjectCollisionShape.shape = null


func _on_Suck_body_entered(body):
	if body.is_in_group("Bodies"):
		body.can_sleep = false
		body.sleeping = false
		
		suckables.append(body)
		print(suckables)


func _on_Suck_body_exited(body):
	suckables.erase(body)
	if body.is_in_group("Bodies"):
		body.can_sleep = true
		body.custom_integrator = false
		if body.is_in_group("Suckables"):
			body.captured = false


func _on_NozzleHole_body_entered(body):
	if Input.is_action_pressed("suck") and !stuck_object:
		if body.is_in_group("Suckables"):
			body.custom_integrator = false
			body.captured = false
			emit_signal("sucked",body)
		if body.is_in_group("Large"):
			stuck_object = body


func _on_StuckObjectTimer_timeout():
	stuck_object.unstick()
	stuck_object = null
	$StuckObjectCollisionShape.shape = null
