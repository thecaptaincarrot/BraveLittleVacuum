extends "res://Enemies/Crawler.gd"
#THIS IS AN AI SCRIPT
#IF IT'S A NEW BEHAVIOR, PUT IT ONE LEVEL UP

var eye_corpse

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
			motion = Vector2(0,0)
			$EyeSprite/RayCast2D.enabled = true
			$AnimatedSprite.animation = "open"
			if seek_direction:
				$EyeSprite.rotate(-delta)
				
				if $EyeSprite.rotation_degrees < -45.0:
					seek_direction = false
			else:
				$EyeSprite.rotate(delta)
				if $EyeSprite.rotation_degrees > 45.0:
					seek_direction = true
			
			if $EyeSprite/RayCast2D.is_colliding():
				pass
			



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
		$WalkTimer.start()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and state != DEAD:
		#Player spotted
		seen_player = true
		state = SEEKING
		$WalkTimer.stop()



func _on_Area2D_body_exited(body):
	if body.is_in_group("Player") and state != DEAD:
		seen_player = false
		state = SEEKING
		$WalkTimer.wait_time = rand_range(8.0,12.0)
		$WalkTimer.start()

func die():
	var new_corpse = corpse.instance()
	new_corpse.position = position
	new_corpse.rotation  = rotation
	new_corpse.apply_central_impulse(floor_direction.rotated(PI) * 30)
	get_parent().call_deferred("add_child",new_corpse)
	queue_free()
