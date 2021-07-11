tool
extends WindowDialog

const TILE = preload("res://addons/BLV_Map_Editor/LevelTile.tscn")

const WORLDDIRECTORY = "res://World/"
const LEVELDIRECTORY = "res://World/Levels/"
const INHERITEDLEVEL = "res://World/Levels/InheritedLevel.tscn"

var panel_root
var level_container

var biomes = ["None", "City"]

var grid = Vector2()
var offset = Vector2()

var dock
var decoder

signal save


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Biome/OptionButton.clear()
	$VBoxContainer/Biome/OptionButton.add_item("None")
	$VBoxContainer/Biome/OptionButton.add_item("City")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func open_menu(grid_position):
	grid = grid_position
	$VBoxContainer/GridPosition/X.text = str(grid.x)
	$VBoxContainer/GridPosition/Y.text = str(grid.y)
	
	$VBoxContainer/LevelSize/XSize.value = 1
	$VBoxContainer/LevelSize/YSize.value = 1
	
	$VBoxContainer/Biome/OptionButton.select(0)
	
	$VBoxContainer/LevelNameBox/LevelName.text = "level " + str(grid)
	
	popup()


func _on_CreateLevel_pressed():
	var level_size = Vector2($VBoxContainer/LevelSize/XSize.value,$VBoxContainer/LevelSize/YSize.value)
	var level_biome = $VBoxContainer/Biome/OptionButton.get_item_text($VBoxContainer/Biome/OptionButton.selected) 
	var level_name = $VBoxContainer/LevelNameBox/LevelName.text
	var decoder_index = LevelDecoder.current_index
	var level_code = "Level" + str(decoder_index)
	var level_notes = $VBoxContainer/Notes.text
	var level_path = LEVELDIRECTORY + level_name + ".tscn"
	
	var new_tile = TILE.instance()
	new_tile.grid_position = grid
	new_tile.grid_size = level_size
	new_tile.biome = level_biome
	new_tile.levelname = level_name
	new_tile.notes = level_notes
	new_tile.levelpath = level_path
	new_tile.offset = offset
	new_tile.levelcode = LevelDecoder.current_index
	
	new_tile.connect("level_selected",dock,"select_level")
	new_tile.connect("level_selected",panel_root,"select_level")
	
	var dir = Directory.new()
	dir.copy(INHERITEDLEVEL,level_path)
	LevelDecoder.add_level_to_dict(level_path)
	LevelDecoder.save_dict()
	
	level_container.add_child(new_tile)
	new_tile.update_rect()
	
	emit_signal("save")
	
	hide()

#	var hack = EditorScript.instance()
#	var editor = hack.get_editor_interface()
#	hack.queue_free()
#	editor.open_scene_from_path("res://World/Levels/InheritedLevel.tscn")
#	editor.set_main_screen_editor("2D")
#
#	#Any edits to the node can be done here
#	var label = Label.new()
#	label.name = "This Is A Brand New Label"
#	get_scene().add_child(label)
#	abel.set_owner(get_scene())
