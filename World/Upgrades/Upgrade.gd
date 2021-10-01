extends AnimatedSprite

var start_position = Vector2(0,0)
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = start_position + Vector2(0,sin(t) * 5)
	t += delta * 5
