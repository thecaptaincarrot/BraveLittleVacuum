extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	update_bar(0.44)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_bar(percentage):
	#Takes in the percentage of health (0 - 1.0) and updates the margins of
	#The color rect to fit.
	$ColorRect.margin_top = 64 - (percentage * 59)
