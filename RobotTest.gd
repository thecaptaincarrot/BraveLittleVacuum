extends Node2D

var shoot_force = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func nozzle_shoot(object,obj_position,obj_rotation):
	var new_rock = object.instance()
	new_rock.position = obj_position
	var vector = Vector2(cos(obj_rotation - PI/2),sin(obj_rotation- PI/2))
	call_deferred("add_child",new_rock)
	new_rock.apply_central_impulse(vector * shoot_force)
