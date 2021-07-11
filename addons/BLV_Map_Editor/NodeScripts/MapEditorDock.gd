tool
extends Control

const EXIT = preload("res://World/LevelExit.tscn")
const EXITMENU = preload("res://Addons/BLV_Map_Editor/ExitContainer.tscn")

const LEVELPATH = "res://World/Levels/"

signal ReturnToOrigin
signal CreateLevel
signal EnterLevel
signal OpenLevel
signal ArchiveLevel

signal Save

var selected_tile
var selected_level = null

var biomes = ["None", "City"]

var main_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	print("MAP EDITOR DOCK READY")
	new_tile(Vector2(1,1))
	
	$PanelContainer/VBoxContainer/LevelStuff/OptionButton.add_item(biomes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func new_tile(grid_position : Vector2):
	$PanelContainer/VBoxContainer/HBoxContainer/TileVector.text = str(grid_position)
	$PanelContainer/VBoxContainer/CreateLevelButton.disabled = false
	$PanelContainer/VBoxContainer/AddExistingButton.disabled = false
	$PanelContainer/VBoxContainer/ArchiveLevel.disabled = true
	$PanelContainer/VBoxContainer/EnterLevel.disabled = true
	$PanelContainer/VBoxContainer/LevelStuff.hide()
	selected_tile = grid_position


func select_level(level_node):
	#The selected tile will have all the information.
	#It must!
	deselect()
	print(level_node)
	$PanelContainer/VBoxContainer/HBoxContainer/TileVector.text = str(level_node.grid_position)
	$PanelContainer/VBoxContainer/CreateLevelButton.disabled = false
	$PanelContainer/VBoxContainer/AddExistingButton.disabled = false
	$PanelContainer/VBoxContainer/ArchiveLevel.disabled = false
	$PanelContainer/VBoxContainer/EnterLevel.disabled = false
	$PanelContainer/VBoxContainer/LevelStuff.show()
	selected_tile = level_node.grid_position
	selected_level = level_node
#	emit_signal("OpenLevel",selected_level.levelpath)
	
	$PanelContainer/VBoxContainer/LevelStuff/CodeContainer/Code.text = str(level_node.levelcode)
	$PanelContainer/VBoxContainer/LevelStuff/LevelName.text = level_node.levelname
	$PanelContainer/VBoxContainer/LevelStuff/GridPositionContainer/GridPosX.value = level_node.grid_position.x
	$PanelContainer/VBoxContainer/LevelStuff/GridPositionContainer/GridPosY.value = level_node.grid_position.y
	
	$PanelContainer/VBoxContainer/LevelStuff/GridSizeContainer/GridSizeX.value = level_node.grid_size.x
	$PanelContainer/VBoxContainer/LevelStuff/GridSizeContainer/GridSizeY.value = level_node.grid_size.y
	
	for exit in level_node.exits:
		print("Exit: ", exit)
	
	$PanelContainer/VBoxContainer/LevelStuff/Notes.text = level_node.notes


func deselect():
	$PanelContainer/VBoxContainer/HBoxContainer/TileVector.text = "None"
	$PanelContainer/VBoxContainer/CreateLevelButton.disabled = true
	$PanelContainer/VBoxContainer/AddExistingButton.disabled = true
	$PanelContainer/VBoxContainer/ArchiveLevel.disabled = true
	$PanelContainer/VBoxContainer/EnterLevel.disabled = true
	$PanelContainer/VBoxContainer/LevelStuff.hide()
	selected_tile = null
	selected_level = null


func _on_ReturnButton_pressed():
	emit_signal("ReturnToOrigin")


func _on_CreateLevelButton_pressed():
	if selected_tile:
		emit_signal("CreateLevel",selected_tile)


func _on_GridSizeX_value_changed(value):
	if selected_level:
		selected_level.grid_size.x = value
		selected_level.update_rect()
		emit_signal("Save")


func _on_GridSizeY_value_changed(value):
	if selected_level:
		selected_level.grid_size.y = value
		selected_level.update_rect()
		emit_signal("Save")


func _on_GridPosX_value_changed(value):
	if selected_level:
		selected_level.grid_position.x = value
		selected_tile = selected_level.grid_position
		$PanelContainer/VBoxContainer/HBoxContainer/TileVector.text = str(selected_level.grid_position)
		selected_level.update_rect()
		emit_signal("Save")


func _on_GridPosY_value_changed(value):
	if selected_level:
		selected_level.grid_position.y = value
		selected_tile = selected_level.grid_position
		$PanelContainer/VBoxContainer/HBoxContainer/TileVector.text = str(selected_level.grid_position)
		selected_level.update_rect()
		emit_signal("Save")


func _on_Notes_text_changed():
	selected_level.notes = $PanelContainer/VBoxContainer/LevelStuff/Notes.text
	emit_signal("Save")


func _on_EnterLevel_pressed():
	if selected_level:
		emit_signal("EnterLevel",selected_level.levelpath)


func _on_OptionButton_item_selected(index):
	if selected_level:
		selected_level.biome = $PanelContainer/VBoxContainer/LevelStuff/OptionButton.get_item_text(index) 
		selected_level.update_rect()
		emit_signal("Save")


func _on_NewExitButton_pressed():
	if selected_level:
		pass
#		emit_signal("OpenLevel",selected_level.levelpath)
		


func _on_LevelName_text_changed(new_text):
	if selected_level:
		var levelcode = selected_level.levelcode
		var old_path = selected_level.levelpath
		print(old_path)
		
		selected_level.levelname = $PanelContainer/VBoxContainer/LevelStuff/LevelName.text
		
		var new_path = LEVELPATH + new_text + ".tscn"
		selected_level.levelpath = new_path
		
		var dir = Directory.new()
		dir.rename(old_path,new_path)
		
		LevelDecoder.level_dict[levelcode] = new_path
		
		emit_signal("Save")


func _on_ArchiveLevel_pressed():
	if selected_level:
		var level_path = selected_level.levelpath
		var level_code = selected_level.levelcode
		
		var dir = Directory.new()
		var new_path ="res://World/Levels/LevelArchive/Level" + level_code + ".tscn"
		dir.rename(level_path,new_path)
		
		LevelDecoder.level_dict[level_code] = new_path
		
		selected_level.queue_free()
		selected_level = null
		
