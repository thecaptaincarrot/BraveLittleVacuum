extends "res://Enemies/Crawler.gd"
#THIS IS AN AI SCRIPT
#IF IT'S A NEW BEHAVIOR, PUT IT ONE LEVEL UP

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
				print($EyeSprite.rotation_degrees)
				if $EyeSprite.rotation_degrees > 45.0:
					seek_direction = true



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
		state = WALK
		$WalkTimer.wait_time = rand_range(5.0,7.0)
		$WalkTimer.start()


func _on_Area2D_body_entered(body):
	print(body)
	if body.is_in_group("Player"):
		print("hola")
		#Player spotted
		seen_player = true
		state = SEEKING
		$WalkTimer.wait_time = rand_range(8.0,12.0)
		$WalkTimer.start()
