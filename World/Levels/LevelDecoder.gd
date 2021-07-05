tool
extends Node

var level_dict = {}

var current_index = 0


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
	var save_game = File.new()
	if not save_game.file_exists("res://Addons/BLV_Map_Editor/level_decoder.json"):
		print("No Save Data Found")
		return #No existing save data
	
	save_game.open("res://Addons/BLV_Map_Editor/level_decoder.json", File.READ)
	
	level_dict = parse_json(save_game.get_line())
	
	current_index = len(level_dict)
	print("new index: ", level_dict)
