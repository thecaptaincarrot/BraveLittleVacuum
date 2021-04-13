extends "res://Enemies/Walker.gd"
#THIS IS AN AI SCRIPT
#IF IT'S A NEW BEHAVIOR, PUT IT ONE LEVEL UP

export (DIRECTIONS) var initial_direction = DIRECTIONS.LEFT

var can_see_player = false

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = initial_direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match direction: #Detection Facing
		DIRECTIONS.RIGHT:
			$Sprite/PlayerDetector.scale.x = 1
		DIRECTIONS.LEFT:
			$Sprite/PlayerDetector.scale.x = -1
	
	if can_see_player and health > 0:
		$WalkTimer.start()
		state = WALK

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("Player"):
		can_see_player = true
		print("Hello Player")


func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("Player"):
		can_see_player = false
		print("Goodbye Player")


func _on_WalkTimer_timeout():
	if state != DEAD:
		state = IDLE
