extends StaticBody2D

onready var BRICK1 = preload("res://SuckableObjects/Brick1.tscn")
onready var BRICK2 = preload("res://SuckableObjects/Brick2.tscn")

signal add_clutter

var fade_out = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_out and $BridgeSprite/Background.modulate.a > 0:
		$BridgeSprite/Background.modulate.a -= delta
		$BridgeSprite/Background2.modulate.a -= delta


func hide():
	visible = false
	$CollapseDetector.monitoring = false
	$CollapseDetector.monitorable = false
	$CollisionShape2D.disabled = true


func collapse():
	$CollisionShape2D.call_deferred("set_disabled",true)
	$CollapseDetector/CollisionShape2D.call_deferred("set_disabled",true)
	collision_layer = 0
	for i in 7:
		var new_brick1 = BRICK1.instance()
		var new_brick2 = BRICK2.instance()
		
		new_brick1.position = Vector2(-72 + i * 24, -2.5) + position
		new_brick2.position = Vector2(-72 + i * 24, 6.5) + position
		
		get_node("/root/Game").current_level.add_clutter(new_brick1)
		get_node("/root/Game").current_level.add_clutter(new_brick2)
	
	$BridgeSprite.self_modulate.a = 0
	fade_out = true


func _on_CollapseDetector_body_entered(body):
	if body.is_in_group("Player"):
		collapse()
