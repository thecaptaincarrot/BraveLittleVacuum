extends "res://Enemies/Walker.gd"

export var can_slope = false #Is able to walk up slopes, otherwise turns around


# Called when the node enters the scene tree for the first time.
func _ready():
	state = WALK
	max_speed = 50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Visual
	match state:
		WALK:
			match direction:
				DIRECTIONS.RIGHT:
					$Hitboxes.scale.x = -1
					$Sprite.flip_h = true
					$Sprite.position.x = 8.0
				DIRECTIONS.LEFT:
					$Hitboxes.scale.x = 1
					$Sprite.flip_h = false
					$Sprite.position.x = -8.0

	#Behavior
	match state:
		WALK:
			motion += walk()


func _on_TerrainDetector_body_entered(body):
	match direction:
		DIRECTIONS.RIGHT:
			direction = DIRECTIONS.LEFT
		DIRECTIONS.LEFT:
			direction = DIRECTIONS.RIGHT
	motion.x = -motion.x
