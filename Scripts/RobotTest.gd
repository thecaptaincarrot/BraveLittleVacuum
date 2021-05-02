extends Node2D

const WATER = preload("res://SuckableObjects/WaterShotPlaceholder.tscn")

var nozzle

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event.is_action_pressed("ui_pause"):
		if !get_tree().paused:
			pause()
		else:
			unpause()


func nozzle_shoot(body):
	var new_rock = SuckableObjects.decode_to_world(body).instance()
	new_rock.position = nozzle.global_position
	new_rock.collision_layer = 0
	new_rock.collision_mask = 5
	var vector = Vector2(cos(nozzle.rotation - PI/2),sin(nozzle.rotation - PI/2))
	$Clutter.call_deferred("add_child",new_rock)
	new_rock.apply_central_impulse(vector * Upgrades.blow_force)


func liquid_nozzle_shoot(unused):
	var new_water = WATER.instance()
	new_water.position = nozzle.global_position
	var vector = Vector2(cos(nozzle.rotation - PI/2),sin(nozzle.rotation - PI/2))
	$Clutter.call_deferred("add_child",new_water)
	new_water.apply_central_impulse(vector * Upgrades.blow_force / 2)


func pause():
	get_tree().paused = true
	$CanvasLayer/UI/Pause.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func unpause():
	get_tree().paused = false
	$CanvasLayer/UI/Pause.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


