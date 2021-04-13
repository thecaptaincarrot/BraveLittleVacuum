extends Node2D

const HOSE = preload("res://Player/Hose.tscn")
const NOZZLE = preload("res://Player/Nozzle.tscn")

export var main_path = ""
var main
var camera

var hose_segments = []

var motion = Vector2(0,0)

var hose_length = 8
var hose_size = 0
var nozzle

var gravity = 9.8
var inertia = 100

signal shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_node(main_path)
	camera = main.get_node("PlayerCamera")
	create_hose_skeleton(hose_length)
	$CanvasLayer/Tank.connect("shoot",main,"nozzle_shoot")
	$CanvasLayer/Tank.connect("liquidshoot",main,"liquid_nozzle_shoot")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	update_line()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func _input(event):
	pass
#	if event.is_action_pressed("Jump"):
#		hose_length += 1
#		create_hose_skeleton(hose_length)



func create_hose_skeleton(length):
	var parent = $PlayerBody/Hose/HoseStart
	var child

	hose_segments.clear()
	hose_segments.append(parent)
	child = add_hose(parent)
	add_anchor_pin(parent,child)
	hose_segments.append(child)
	parent = child
	
	for i in range (hose_length):
		child = add_hose(parent)
		add_pin(parent,child)
		hose_segments.append(child)
		parent = child
	
	child = add_nozzle(parent)
	nozzle = child
	add_pin_nozzle(parent,child)
	
	for base_hose in hose_segments:
		for hose in hose_segments:
			base_hose.add_collision_exception_with(hose)
	
	update_line()


func remove_hose():
	pass


func add_hose(parent):
	var new_hose = HOSE.instance()
	hose_size = new_hose.size
	new_hose.position = parent.position
	new_hose.position.y -= 2 * hose_size
	
	new_hose.previous_segment = parent
	if parent.name != "HoseStart":
		parent.next_segment = new_hose
	
	$PlayerBody/Hose.add_child(new_hose)
	return new_hose


func add_nozzle(parent):
	var new_nozzle = NOZZLE.instance()
	new_nozzle.position = parent.position
	
	new_nozzle.anchor = $PlayerBody/Hose/HoseStart
	
	new_nozzle.connect("sucked", $CanvasLayer/Tank, "add_suckable")
	new_nozzle.connect("liquid_sucked", $CanvasLayer/Tank, "add_liquid")
	
	new_nozzle.limit = (hose_size + 1) * hose_length * 2
	new_nozzle.collision_limit = new_nozzle.limit + 5
	
	main.nozzle = new_nozzle #fix this to be the Main variable, as it were
	camera.nozzle = new_nozzle
	
	$PlayerBody/Hose.add_child(new_nozzle)
	return new_nozzle


func add_anchor_pin(parent,child):
	var pin = PinJoint2D.new()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	pin.softness = 0.05
	pin.bias = .9
	pin.disable_collision = true
	parent.add_child(pin)


func add_pin(parent,child):
	var pin = PinJoint2D.new()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	pin.softness = 0.05
	pin.bias = .1
	pin.disable_collision = true
	parent.add_child(pin)


func add_pin_nozzle(parent,child):
	var pin = PinJoint2D.new()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	pin.softness = 0.05
	pin.bias = 0.0
	pin.disable_collision = true
	parent.add_child(pin)


func update_line():
	var i = 0
	
	var line = $PlayerBody/Hose/Line2D
	
	if len(hose_segments) != len(line.points):
		line.clear_points()
		line.add_point(Vector2(0,0))
		for j in range(len(hose_segments)):
			line.add_point(Vector2(0,0))
			pass
	
	line.points[i] = Vector2(0,0)
	i += 1
	
	for hose in hose_segments:
		if hose != null:
			line.points[i] = hose.position
			i += 1


func check_hose_length():
	var length = 0
	var start_position = hose_segments[0].position
	for N in hose_segments:
		length += start_position.distance_to(N.position)
		start_position = N.position
	
	return length


func collide_hose():
	for N in hose_segments:
		N.collision_layer = 4
		N.collision_mask = 4
	

func uncollide_hose():
	for N in hose_segments:
		N.collision_layer = 0
		N.collision_mask = 0
