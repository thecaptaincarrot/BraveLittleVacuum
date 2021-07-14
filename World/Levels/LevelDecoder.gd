tool
extends Node

var level_dict = {}

var current_index = 0


func _ready():
	if !Engine.editor_hint:
		load_dict()


func add_level_to_dict(level_path):
	level_dict[current_index] = level_path
	current_index += 1


func archive_level(index):
	pass


func save_dict():
	var save_game = File.new()
	save_game.open("res://Addons/BLV_Map_Editor/level_decoder.json", File.WRITE)
	
	save_game.store_line(to_json(level_dict))
	
	save_game.close()


func load_dict():
	level_dict = {}
	var save_game = File.new()
	if not save_game.file_exists("res://Addons/BLV_Map_Editor/level_decoder.json"):
		print("No Save Data Found")
		return #No existing save data
	
	save_game.open("res://Addons/BLV_Map_Editor/level_decoder.json", File.READ)
	
	var str_level_dict = parse_json(save_game.get_line())
	
	for key in str_level_dict.keys():
		level_dict[int(key)]=str_level_dict[key]
	
	for key in level_dict.keys():
		print(typeof(key)," ", key)
	
	current_index = len(level_dict)
	print("new index: ", level_dict)
