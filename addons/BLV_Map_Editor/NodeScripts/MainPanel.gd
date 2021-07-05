tool
extends Control

const SELECTION = preload("res://addons/BLV_Map_Editor/SelectedSprite.tscn")

var viewport_position

var panel_offset = Vector2(0,0)
var grid_offset = Vector2(16,16)

var dock

signal tile_selected
signal deselect


# Called when the node enters the scene tree for the first time.
func _ready():
	$ScrollContainer/PanelContainer/Yaxis.add_point(Vector2(-32 + grid_offset.x * 64,0))
	$ScrollContainer/PanelContainer/Yaxis.add_point(Vector2(-32 + grid_offset.x * 64,99 * 64))

	$ScrollContainer/PanelContainer/Xaxis.add_point(Vector2(0,-32 + grid_offset.y * 64))
	$ScrollContainer/PanelContainer/Xaxis.add_point(Vector2(99 * 64,-32 + grid_offset.y * 64))
	
	$Popups/WindowDialog.panel_root = self
	$Popups/WindowDialog.level_container = $ScrollContainer/PanelContainer/LevelContainer
	$Popups/WindowDialog.offset = grid_offset - Vector2(1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _gui_input(event):
	if event is InputEventMouseButton and is_visible_in_tree() and event.button_index == BUTTON_LEFT and event.pressed:
		var viewport_position = get_local_mouse_position() - panel_offset #offset
		viewport_position.x += $ScrollContainer.scroll_horizontal
		viewport_position.y += $ScrollContainer.scroll_vertical
		emit_signal("deselect")
		if viewport_position.x < 32 or viewport_position.y < 32:
			return
		var grid_position = Vector2(stepify(viewport_position.x,64)/64,stepify(viewport_position.y,64)/64) - grid_offset
		
		emit_signal("tile_selected",grid_position)
		emit_signal("deselect")
		
		var new_select = SELECTION.instance()
		new_select.position	 = Vector2(stepify(viewport_position.x,64),stepify(viewport_position.y,64)) + panel_offset
		$ScrollContainer/PanelContainer.add_child(new_select)
		connect("deselect",new_select,"queue_free")


func origin_return():
	$ScrollContainer.set_h_scroll(grid_offset.x * 32)
	$ScrollContainer.set_v_scroll(grid_offset.y * 32)


func open_level_dialogue(tile):
	$Popups/WindowDialog.open_menu(tile)


func select_level(_level):
	emit_signal("deselect")
