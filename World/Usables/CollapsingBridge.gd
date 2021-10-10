extends StaticBody2D

onready var BRICK1 = preload("res://SuckableObjects/Brick1.tscn")
onready var BRICK2 = preload("res://SuckableObjects/Brick2.tscn")

var fade_out = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_out and $BridgeSprite/Background.modulate.a > 0:
		$BridgeSprite/Background.modulate.a -= delta


func hide():
	visible = false
	$CollapseDetector.monitoring = false
	$CollapseDetector.monitorable = false
	$CollisionShape2D.disabled = true


func collapse():
	$CollisionShape2D.disabled = true
	collision_layer = 0
	for i in range(0,4):
		var new_brick1 = BRICK1.instance()
		var new_brick2 = BRICK2.instance()
		
		new_brick1.position = Vector2(-99 + i * 48, -5)
		new_brick2.position = Vector2(-99 + i * 48, 13)
		add_child(new_brick1)
		add_child(new_brick2)
	
	$BridgeSprite.self_modulate.a = 0
	fade_out = true


func _on_CollapseDetector_body_entered(body):
	if body.is_in_group("Player"):
		collapse()
