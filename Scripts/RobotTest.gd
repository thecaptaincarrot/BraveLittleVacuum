extends Node2D

const WATER = preload("res://SuckableObjects/WaterShotPlaceholder.tscn")

var shoot_force = 500
var nozzle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func nozzle_shoot(body):
	var new_rock = SuckableObjects.decode_to_world(body).instance()
	new_rock.position = nozzle.position
	new_rock.collision_layer = 0
	new_rock.collision_mask = 1025
	var vector = Vector2(cos(nozzle.rotation - PI/2),sin(nozzle.rotation - PI/2))
	$Clutter.call_deferred("add_child",new_rock)
	new_rock.apply_central_impulse(vector * shoot_force)


func liquid_nozzle_shoot(unused):
	var new_water = WATER.instance()
	new_water.position = nozzle.position
	var vector = Vector2(cos(nozzle.rotation - PI/2),sin(nozzle.rotation - PI/2))
	$Clutter.call_deferred("add_child",new_water)
	new_water.apply_central_impulse(vector * shoot_force / 2)
