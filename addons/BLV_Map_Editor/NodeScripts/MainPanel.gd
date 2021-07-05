tool
extends Control

const SELECTION = preload("res://addons/BLV_Map_Editor/SelectedSprite.tscn")
const TILE = preload("res://Addons/BLV_Map_Editor/LevelTile.tscn")

var viewport_position

var panel_offset = Vector2(0,0)
var grid_offset = Vector2(16,16)

var dock

signal tile_selected
signal deselect

var level_tiles = {} #I'm a fuck head and the only key is "tiles"

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


func save_tiles():
	var tiles_array = []
	for tile in $ScrollContainer/PanelContainer/LevelContainer.get_children():
		var tile_info = {}
		tile_info["grid_position"] = var2str(tile.grid_position)
		tile_info["grid_size"]= var2str(tile.grid_size)
		tile_info["levelname"]= tile.levelname
		tile_info["levelpath"]= tile.levelpath
		tile_info["levelcode"]= tile.levelcode
		tile_info["biome"]= tile.biome
		tile_info["exits"]= tile.exits
		tile_info["icons"]= tile.icons
		tile_info["notes"]= tile.notes
		
		tiles_array.append(tile_info)
	
	var save_game = File.new()
	save_game.open("res://Addons/BLV_Map_Editor/tiles.json", File.WRITE)
	
	save_game.store_line(to_json({"Tiles":tiles_array}))
	
	save_game.close()


func _on_WindowDialog_save():
	save_tiles()


func load_tiles():
	var save_game = File.new()
	if not save_game.file_exists("res://Addons/BLV_Map_Editor/tiles.json"):
		print("No Tile Save Data Found")
		return #No existing save data
	
	save_game.open("res://Addons/BLV_Map_Editor/tiles.json", File.READ)
	
	var tiles = parse_json(save_game.get_line())["Tiles"]
	
	for tile_info in tiles:
		var new_tile = TILE.instance()
		new_tile.grid_position = str2var(tile_info["grid_position"])
		new_tile.offset = grid_offset
		new_tile.grid_size = str2var(tile_info["grid_size"])
		new_tile.levelname = tile_info["levelname"]
		new_tile.levelpath = tile_info["levelpath"]
		new_tile.levelcode = tile_info["levelcode"]
		new_tile.biome = tile_info["biome"]
		new_tile.exits = tile_info["exits"]
		new_tile.icons = tile_info["icons"]
		new_tile.notes = tile_info["notes"] 
		
		$ScrollContainer/PanelContainer/LevelContainer.add_child(new_tile)
		new_tile.update_rect()
		
		new_tile.connect("level_selected",dock,"select_level")
		new_tile.connect("level_selected",self,"select_level")
