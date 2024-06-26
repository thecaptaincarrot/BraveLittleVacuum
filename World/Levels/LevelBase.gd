extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CameraBound/ReferenceRect.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_entry(entry_number):
	match entry_number:
		0:
			return $Entry0.position
		1:
			return $Entry1.position
		2:
			return $Entry2.position
		3:
			return $Entry3.position
		4:
			return $Entry4.position


func get_exit(exit_number):
	return $Exits.get_child(exit_number)


func get_exits():
	return $Exits.get_children()


func get_upgrades():
	return $World/Upgrades.get_children()


func get_camera_bounds():
	return [$CameraBound.rect_position,$CameraBound.rect_size]


func add_clutter(clutter_to_add):
	$Clutter.call_deferred("add_child",clutter_to_add)
