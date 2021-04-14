extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().animation == "Default":
		if get_parent().frame % 2 == 0:
			offset = Vector2(0,0)
		else:
			offset = Vector2(0,1)
	else:
		if get_parent().frame % 2 == 0:
			offset = Vector2(0,1)
		else:
			if flip_h:
				offset = Vector2(1,2)
			else:
				offset = Vector2(-1,2)


func _on_NewAnimation_timeout():
	$NewAnimation.wait_time = rand_range(1.0,2.0)
	var animations = frames.get_animation_names()
	
	var next_anim = randi() % len(animations)
	
	animation = animations[next_anim]
	$NewAnimation.start()
