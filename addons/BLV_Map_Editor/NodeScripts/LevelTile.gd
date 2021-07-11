tool
extends ColorRect

var offset : Vector2 #This has to be inherited
#Innate level information
var grid_position : Vector2
var grid_size : Vector2
var levelname : String
var levelpath : String
var levelcode
var biome
var exits = []
var icons = []
var notes : String

var mouse_in

signal level_selected


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = levelname


func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and mouse_in:
		print("clicked on ", name)
		emit_signal("level_selected",self)
		pass


func add_exit(grid_position):
	var new_line = Line2D.new()
	new_line.add_point(rect_size.x)


func update_rect():
	rect_position = Vector2(-32 + (grid_position.x + offset.x) * 64, -32 + (grid_position.y + offset.y) * 64)
	rect_size = grid_size * 64
	match biome:
		"None":
			self_modulate = Color.white
		"City":
			self_modulate = Color.paleturquoise


func _on_LevelTile_mouse_entered():
	mouse_in = true


func _on_LevelTile_mouse_exited():
	mouse_in = false


