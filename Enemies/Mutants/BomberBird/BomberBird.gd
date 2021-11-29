extends "res://Enemies/Walker.gd"

var BOMB = preload("res://Enemies/Mutants/BomberBird/BirdBomb.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	state = ATTACK # Replace with function body.
	gravity = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#AI

	match state:
		IDLE:
#			motion = Vector2(0,Globals.GRAVITY)
			if !$BombReleaseTimer.is_stopped:
				$BombReleaseTimer.stop()
		ATTACK:
			if $BombReleaseTimer.is_stopped():
				$BombReleaseTimer.start()
		DEAD:
			if !$BombReleaseTimer.is_stopped():
				$BombReleaseTimer.stop()
			$Sprite.animation = "Dead"
			gravity = true
			motion = Vector2(0,Globals.GRAVITY)
			modulate = Color.darkgray


func _on_BombReleaseTimer_timeout():
	var bomb = BOMB.instance()
	bomb.add_collision_exception_with(self)
	bomb.global_position = $Hitboxes/Position2D.global_position
	get_parent().add_child(bomb)
