extends Sprite

var Rock = preload("res://TankRock.tscn")

var blow_force = 5

signal shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("blow"):
		for object in $Contents.get_children():
			var vector = $Exit.position - object.position
			object.apply_central_impulse(vector.normalized() * blow_force)


func add_suckable(body):
	var new_rock = Rock.instance()
	new_rock.position.y -= 5
	$Contents.call_deferred("add_child",new_rock)


func blow():
	pass


func _on_Exit_body_entered(body):
	if Input.is_action_pressed("blow"):
		print("goodbye",body)
		emit_signal("shoot",body)
		body.queue_free()
