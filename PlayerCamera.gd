extends Camera2D

export var player_path = ""
var player
var nozzle 

var camera_drag = .05
var nozzle_reduction = 3

var player_in = true

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player_in:
		var target_pos = Vector2()
		if (player.position.x < position.x - $Area2D/CollisionShape2D.shape.extents.x) or (player.position.x > position.x + $Area2D/CollisionShape2D.shape.extents.x):
			position.x = lerp(position.x, player.position.x,camera_drag)
		if (player.position.y < position.y - $Area2D/CollisionShape2D.shape.extents.y) or (player.position.y > position.y + $Area2D/CollisionShape2D.shape.extents.y):
			position.y = lerp(position.y, player.position.y,camera_drag)
	
	if nozzle != null:
		offset.x = nozzle.position.x / nozzle_reduction
		offset.y = nozzle.position.y / nozzle_reduction
	else:
		offset = Vector2(0,0)


func _on_Area2D_body_entered(body):
	if body == player:
		player_in = true


func _on_Area2D_body_exited(body):
	if body == player:
		player_in = false
