extends RigidBody2D

signal freed

var type = "Water"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass



func _on_Area2D_body_entered(body):
	if body.is_in_group("World"):
		emit_signal("freed",self)
		queue_free()
		#Do some kind of splash
