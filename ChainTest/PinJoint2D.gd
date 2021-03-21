extends PinJoint2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	node_a = get_parent().get_path()
	node_b = get_parent().get_node("Connector").get_path()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
