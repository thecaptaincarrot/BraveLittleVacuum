tool
extends Area2D

export var level_code = 0
export var target_exit = 0

var exit_speed = 200 #should this be done on the player level?

export (String, "RIGHT", "LEFT", "UP", "DOWN" ) var enter_direction #Direction to enter, exit is opposite

var mouse_in = false

signal level_exit

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.editor_hint:
		$Node2D.hide()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		if $Node2D/Destination.text != str(level_code):
			$Node2D/Destination.text = str(level_code)
		match enter_direction:
			"RIGHT":
				$Node2D/RayCast2D.cast_to = Vector2(5,0)
			"LEFT":
				$Node2D/RayCast2D.cast_to = Vector2(-5,0)
			"UP":
				$Node2D/RayCast2D.cast_to = Vector2(0,-5)
			"DOWN":
				$Node2D/RayCast2D.cast_to = Vector2(0,5)


func _on_LevelExit_body_entered(body):
	if body.is_in_group("Player"):
		print("Emitting Signal")
		emit_signal("level_exit",level_code,target_exit)
		if !body.force_move:
			body.force_move = true
			var vector = Vector2(0,0)
			match enter_direction:
				"RIGHT":
					vector = Vector2(1,0)
				"LEFT":
					vector = Vector2(-1,0)
				"UP":
					vector = Vector2(0,-1)
				"DOWN":
					vector = Vector2(0,1)
			print("Vector ",body.max_speed * -vector)
			body.force_move_vector = body.max_speed * -vector
