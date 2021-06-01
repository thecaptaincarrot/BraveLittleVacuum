extends AnimatedSprite

var PlayerSprite
var PlayerBody
var PlayerNode

var hover_start = true

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerSprite = get_parent()
	PlayerBody = PlayerSprite.get_parent()
	PlayerNode = PlayerBody.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Offset Get
	if PlayerSprite.animation == "Default":
		if PlayerSprite.frame % 2 == 0:
			offset = Vector2(0,0)
		else:
			offset = Vector2(0,1)
	elif PlayerSprite.animation == "Sucking":
		if PlayerSprite.frame % 2 == 0:
			offset = Vector2(0,1)
		else:
			if flip_h:
				offset = Vector2(1,2)
			else:
				offset = Vector2(-1,2)
	elif PlayerSprite.animation == "Shocked":
		animation = "hurt"
		if PlayerSprite.frame % 2 == 1:
			offset = Vector2(0,1)
		else:
			if flip_h:
				offset = Vector2(1,2)
			else:
				offset = Vector2(-1,2)
	else:
		offset = Vector2(0,0)

func _on_NewAnimation_timeout():
	$NewAnimation.wait_time = rand_range(1.0,2.0)
	var animations = frames.get_animation_names()
	#Default
	if true: #Health is high
		animations = ["happy","blink","doubleblink"]
	
	var next_anim = randi() % len(animations)
	
	animation = animations[next_anim]
	$NewAnimation.start()
