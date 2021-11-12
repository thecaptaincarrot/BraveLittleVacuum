extends "res://Enemies/Enemy.gd"

enum {IDLE, FLY, FLYBLIND, SEARCHING, DEAD, HURT}

var player_body = null

#random flight variables
var fly_random_anchor = Vector2(0,0)
var fly_random_destination = Vector2(0,0)

export var fly_acceleration = .5
export var max_speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.PLAYER:
		player_body = Globals.PLAYER.body


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion = move_and_slide(motion, Vector2(0,-1))


func fly_towards(destination : Vector2):
	var fly_vector = Vector2(0,0)
	
	var direction_vector = (destination - position).normalized()
	fly_vector = direction_vector * fly_acceleration
	
	return fly_vector


func fly_random(random_radius):
	#get base position
	#choose random vector2 within certain radius
	#fly towards position
	#if collide, change target ****to-do****
	var fly_to_x = rand_range(-random_radius, random_radius)
	var fly_to_y = rand_range(-random_radius, random_radius)
	
	fly_random_destination = fly_random_anchor + Vector2(fly_to_x,fly_to_y)


func die():
	state = DEAD
	collision_layer = 0
