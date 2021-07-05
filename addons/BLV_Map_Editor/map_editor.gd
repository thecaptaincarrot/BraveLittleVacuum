tool
extends EditorPlugin


const MAINWINDOW = preload("res://addons/BLV_Map_Editor/MainPanel.tscn")
const DOCK = preload("res://addons/BLV_Map_Editor/MapEditorDock.tscn")
const POPUP = preload("res://addons/BLV_Map_Editor/LevelCreateDialogue.tscn")

var MainPanel
var Dock

func _enter_tree():
	MainPanel = MAINWINDOW.instance()
	Dock = DOCK.instance()
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_viewport().add_child(MainPanel)
	# Hide the main panel. Very much required.
	make_visible(false)
	
	MainPanel.dock = Dock
	Dock.main_screen = MainPanel
	MainPanel.get_node("Popups/WindowDialog").dock = Dock
	print("dock check 2: ",MainPanel.get_node("Popups/WindowDialog").dock)
	
	#add loaded scene to dock
	connect("main_screen_changed",self,"_on_main_screen_changed")
	Dock.connect("EnterLevel",self,"go_to_level")
	Dock.connect("OpenLevel",self,"open_level")
	#add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL,Dock)
	


func _exit_tree():
	if MainPanel:
		MainPanel.queue_free()
	
	if Dock:
		remove_control_from_docks(Dock)
		Dock.queue_free()
	#dock.free()


func _ready():
	print("MAP EDITOR READY")
	MainPanel.connect("tile_selected",self,"select_tile")
	#Dock To Panel
	Dock.connect("ReturnToOrigin",MainPanel,"origin_return")
	Dock.connect("CreateLevel",MainPanel,"open_level_dialogue")
	var base = get_editor_interface().get_base_control()


func has_main_screen():
	return true
	

func make_visible(visible):
	if MainPanel:
		MainPanel.visible = visible


func get_plugin_name():
	return "MapEditor"


func get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return get_editor_interface().get_base_control().get_icon("TileMap", "EditorIcons")


#Non-native functions
func select_tile(grid_position : Vector2):
	print("Selected Map tile: ", grid_position)
	Dock.new_tile(grid_position)


func go_to_level(level_path):
	var editor = get_editor_interface()
	editor.open_scene_from_path(level_path)
	editor.set_main_screen_editor("2D")


func open_level(level_path):
	var editor = get_editor_interface()
	editor.open_scene_from_path(level_path)


#signals
func _on_main_screen_changed(main_screen : String):
	if main_screen == "MapEditor":
		add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL,Dock)
	else:
		remove_control_from_docks(Dock)
