extends "res://Enemies/Flier.gd"

var last_known_position

var player_detected = false

var PIECES = preload("res://Enemies/Mutants/Bug/BugPieces.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#AI
	match state: 
		IDLE: #No player in sight, motionless
			motion = Vector2(0,0)
			if player_body:
				if !$VisionRay.get_collider() and player_detected: #player is in detection zone and line of sight gained
					state = FLY
		FLY: #Can see player, flying towards their position
			modulate = Color.white
			if player_body:
				if !$VisionRay.get_collider(): #Has lien of sight
					motion += fly_towards(player_body.position)
				else: #lost line of sight
					last_known_position = $VisionRay.get_collision_point()
					state = FLYBLIND
			if motion.length() > max_speed:
				motion = motion.normalized() * max_speed
		FLYBLIND:
			modulate = Color.red
			if player_body:
				if !$VisionRay.get_collider() and player_detected: #regain line of sight
					state = FLY
					#two behaviors:
					#1. fly towards last known position
					#2. if reasonably close to last known position, go to searching
			motion += fly_towards(last_known_position)
			if position.distance_to(last_known_position) <= 32.0: #Perhaps change distance tolerance
				fly_random_anchor = position
				fly_random(12.0)
				print("New Fly Random: ", fly_random_destination)
				state = SEARCHING
			if motion.length() > max_speed:
				motion = motion.normalized() * max_speed
		SEARCHING: #Fly towards last known player position
			modulate = Color.blue
			if player_body:
				if !$VisionRay.get_collider() and player_detected: #has line of sight
					$FlyRandomPause.stop()
					state = FLY
			#fly_random to find the fly_towards position
			#fly towards that position
			#when approach, generate new fly_random
			if position.distance_to(fly_random_destination) <= 8.0 or (is_on_wall() or is_on_floor() or is_on_ceiling()):#if reached fly_randon destination
				if $FlyRandomPause.is_stopped():
					$FlyRandomPause.start()
			
			motion += fly_towards(fly_random_destination)
			if motion.length() > max_speed:
				motion = motion.normalized() * max_speed
			
	#Animation
	match state:
		IDLE:
			$Sprite.animation = "Idle"
		FLY:
			$Sprite.animation = "Fly"
			if motion.x < 0:
				$Sprite.flip_h = true
			else:
				$Sprite.flip_h = false


func _physics_process(delta):
	if Globals.PLAYER:
		$VisionRay.cast_to = Globals.PLAYER.body.position - position


func die():
	state = DEAD
	var new_pieces = PIECES.instance()
	new_pieces.position = position
	get_parent().call_deferred("add_child",new_pieces)
	queue_free()


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("Player"):
		player_detected = true


func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("Player"):
		player_detected = false


func _on_FlyRandomPause_timeout():
	fly_random(12.0) # Generate new fly_random vector #change radius to do
	print("New Fly Random: ", fly_random_destination)
