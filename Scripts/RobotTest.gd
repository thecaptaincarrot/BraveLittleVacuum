extends Node2D

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
	var vector = Vector2(cos(nozzle.rotation - PI/2),sin(nozzle.rotation - PI/2))
	$Clutter.call_deferred("add_child",new_rock)
	new_rock.apply_central_impulse(vector * shoot_force)
