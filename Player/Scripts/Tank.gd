extends Sprite

var blow_force = 20

var size = 30
var current_size = 0

var liquid_level = 0
var liquid_types = []

var to_shoot = []

signal shoot
signal liquidshoot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("blow"):
		for object in $Contents.get_children():
			var vector = $Exit.position - object.position
			object.apply_central_impulse(vector.normalized() * blow_force)
			if $SolidShotTimer.is_stopped():
				if !to_shoot == []:
					to_shoot.shuffle()
					var body = to_shoot[0]
					emit_signal("shoot",body)
					to_shoot.erase(body)
					body.queue_free()
					current_size -= body.size
					$SolidShotTimer.start()
		if liquid_level > 0 and $LiquidShotTimer.is_stopped():
			$Watercolum.show()
			$Watercolum/WaterTimer.start()
			liquid_level -= 1
			$LiquidShotTimer.start()
			emit_signal("liquidshoot",null)
	
		
	
	#liquid level
	$Water.scale.y = lerp($Water.scale.y,liquid_level / float(size),.1)
	$Water.position.y = lerp($Water.position.y,33 - ($Water.scale.y * 33) - 1,.1)
	$Watercolum.scale.y = lerp($Watercolum.scale.y, 1.0 - .9* (liquid_level / float(size)),.1)
	$Watercolum.position.y = lerp($Watercolum.position.y,-32 * (liquid_level / float(size)) + 4,.1)


func add_suckable(body):
	if current_size + body.size <= size:
		body.queue_free()
		var new_contents = SuckableObjects.decode_to_tank(body).instance()
		new_contents.position.y -= 35
		current_size += body.size
		$Contents.call_deferred("add_child",new_contents)


func add_liquid(body):
	if liquid_level < size:
		body.queue_free()
		liquid_level += 1
		$Watercolum/WaterTimer.start()
		$Watercolum.show()
		#animation
		#Change color based on contents


func _on_Exit_body_entered(body):
	if body != $TankSTatic:
		to_shoot.append(body)


func _on_Exit_body_exited(body):
	to_shoot.erase(body)


func _on_WaterTimer_timeout():
	$Watercolum.hide()
