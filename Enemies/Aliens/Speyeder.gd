extends "res://Enemies/Crawler.gd"
#THIS IS AN AI SCRIPT
#IF IT'S A NEW BEHAVIOR, PUT IT ONE LEVEL UP

onready var eye_corpse = preload("res://SuckableObjects/SpiderEye.tscn")

export (DIRECTIONS) var initial_direction = DIRECTIONS.LEFT

var seen_player = false

var seek_direction = false

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = initial_direction
	state = WALK


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		SEEKING:
			if !seen_player and $WalkTimer.is_stopped():
				$WalkTimer.wait_time = rand_range(8.0,12.0)
				$WalkTimer.start()
			motion = Vector2(0,0)
			$EyeSprite/RayCast2D.enabled = true
			$AnimatedSprite.animation = "open"
			$EyeSprite.animation = "default"
			if seek_direction:
				$EyeSprite.rotate(-delta)
				
				if $EyeSprite.rotation_degrees < -45.0:
					seek_direction = false
			else:
				$EyeSprite.rotate(delta)
				if $EyeSprite.rotation_degrees > 45.0:
					seek_direction = true
			
			if $EyeSprite/RayCast2D.is_colliding():
				$EyeSprite/EyeBeam.modulate.a = 0
				$EyeSprite/EyeBeam.default_color = Color.lightgray
				$EyeSprite/EyeBeam.show()
				state = FIRING
		FIRING:
			$WalkTimer.stop()
			if $EyeSprite/EyeBeam.modulate.a >= 1.0:
				$EyeSprite.animation = "shooting"
				$EyeSprite/EyeBeam.default_color = Color.lightblue
				if $ShootTimer.is_stopped():
					$ShootTimer.start()
			else:
				$EyeSprite/EyeBeam.modulate.a += delta
				$EyeSprite.animation = "fire"



func _on_WalkTimer_timeout():
	if state == WALK:
		state = IDLE
		$WalkTimer.wait_time = rand_range(2.0,4.0)
		$WalkTimer.start()
	elif state == IDLE:
		state = WALK
		$WalkTimer.wait_time = rand_range(5.0,7.0)
		$WalkTimer.start()
	elif state == SEEKING:
		$AnimatedSprite.play("open",true)
		var t = Timer.new()
		t.wait_time = 0.4
		add_child(t)
		t.start()
		yield(t,"timeout")
		t.queue_free()
		$AnimatedSprite.play("walk",false)
		state = WALK
		$WalkTimer.wait_time = rand_range(5.0,7.0)
		$EyeSprite.rotation = 0.0
		$WalkTimer.start()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and (state == WALK or state == IDLE):
		#Player spotted
		seen_player = true
		state = SEEKING
		$WalkTimer.stop()



func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		seen_player = false


func die():
	var new_eye = eye_corpse.instance()
	new_eye.position = position
	new_eye.rotation = rotation
	new_eye.apply_central_impulse(floor_direction.rotated(PI) * 40)
	new_eye.apply_torque_impulse(500.0)
	get_parent().call_deferred("add_child",new_eye)
	
	var new_corpse = corpse.instance()
	new_corpse.position = position
	new_corpse.rotation  = rotation
	new_corpse.apply_central_impulse(floor_direction.rotated(PI) * 30)
	new_corpse.apply_torque_impulse(500.0)
	get_parent().call_deferred("add_child",new_corpse)
	queue_free()



func _on_ShootTimer_timeout():
	print("done shooting")
	$EyeSprite/EyeBeam.hide()
	state = SEEKING
