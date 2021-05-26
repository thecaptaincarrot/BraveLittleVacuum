extends AnimatedSprite

var PlayerBody

var hover_start = true

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerBody = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if PlayerBody.is_on_floor():
		if Input.is_action_pressed("suck") or Input.is_action_pressed("blow"):
			animation = "Sucking"
		else:
			animation = "Default"
	else:
		if PlayerBody.is_hovering:
			if hover_start:
				animation = "Hover"
			else:
				animation = "HoverLoop"
		elif PlayerBody.can_hover == false:
			animation = "HoverSpent"
		else:
			hover_start = true
			animation = "Jump"
	


func _on_PlayerSprite_animation_finished():
	if animation == "Hover":
		 hover_start = false
