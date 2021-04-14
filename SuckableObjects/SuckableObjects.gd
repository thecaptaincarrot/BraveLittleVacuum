extends Node

const ERROR = preload("res://SuckableObjects/DEFAULT.tscn")
const ERRORTANK= preload("res://SuckableObjects/DEFAULT_TANK.tscn")

const EYE = preload("res://SuckableObjects/SpiderEye.tscn")
const EYETANK = preload("res://SuckableObjects/SpiderEyeTank.tscn")

const ROCK = preload("res://SuckableObjects/Rock.tscn")
const ROCKTANK = preload("res://SuckableObjects/RockTank.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func decode_to_tank(body):
	var body_to_tank
	match body.identifier:
		"Rock":
			return ROCKTANK
		"SpiderEye":
			return EYETANK
	
	return ERRORTANK


func decode_to_world(body):
	var body_to_tank
	match body.identifier:
		"Rock":
			return ROCK
		"SpiderEye":
			return EYE
	
	return ERROR
