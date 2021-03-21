extends Node2D

const LOOP = preload("res://Chain.tscn")
const PIN = preload("res://PinJoint2D.tscn")
const TESTLOOP = preload("res://KinChain.tscn")

var loops = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = $Anchor
	var child
	for i in range (loops):
		child = add_loop(parent)
		add_link(parent,child)
		parent = child
	child = add_kin_link(parent,child)
	add_link(parent,child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func add_loop(parent):
	var loop = LOOP.instance()
	loop.position = parent.position
	loop.position.y -= 3
	parent.add_child(loop)
	return loop


func add_link(parent,child):
	var pin = PIN.instance()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	parent.add_child(pin)


func add_kin_link(parent,child):
	var loop = TESTLOOP.instance()
	loop.position = parent.position
	loop.position.y -= 12
	loop.position.x += 5
	add_child(loop)
	return loop
