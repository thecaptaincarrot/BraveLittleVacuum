extends Sprite

var blow_force = 5

var size = 30
var current_size = 0

var to_shoot = []

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
			if $Timer.is_stopped():
				if !to_shoot == []:
					to_shoot.shuffle()
					var body = to_shoot[0]
					emit_signal("shoot",body)
					to_shoot.erase(body)
					body.queue_free()
					current_size -= body.size
					print(current_size)
					$Timer.start()


func add_suckable(body):
	if current_size + body.size <= size:
		body.queue_free()
		var new_contents = SuckableObjects.decode_to_tank(body).instance()
		new_contents.position.y -= 30
		current_size += body.size
		$Contents.call_deferred("add_child",new_contents)


func _on_Exit_body_entered(body):
	if Input.is_action_pressed("blow"):
		to_shoot.append(body)



func _on_Exit_body_exited(body):
	to_shoot.erase(body)
