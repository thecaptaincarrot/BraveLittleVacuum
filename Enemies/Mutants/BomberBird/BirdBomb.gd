extends "res://Enemies/Flier.gd"

var last_known_position = Vector2(0,0)
export var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	state = FLY #I don't think it'll ever have a different state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#AI
	match state: 
		IDLE: #No player in sight, motionless
			pass
			#I should never be idling
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
				if !$VisionRay.get_collider(): #regain line of sight
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
				if !$VisionRay.get_collider(): #has line of sight
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
		DEAD:
			motion = Vector2(0,0)
			$Collider.disabled = true
			
	#Animation
	match state:
		FLY:
			$Sprite.animation = "Fly"
		DEAD:
			$Sprite.animation = "Die"


func die():
	state = DEAD


func _on_PlayerCollisionDetector_body_entered(body):
	if body.is_in_group("Player") and state != DEAD:
		Globals.PLAYER.hurt(damage)
		state = DEAD


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Die":
		queue_free()


func _on_DeathTimer_timeout():
	die()


func _on_FlyRandomPause_timeout():
	fly_random(12.0) # Generate new fly_random vector #change radius to do
