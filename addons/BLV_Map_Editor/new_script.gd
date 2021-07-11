tool
extends EditorScript


func _run():
	var editor = get_editor_interface()
	
	var dir = Directory.new()
	dir.copy("res://addons/BLV_Map_Editor/LevelPlaceholder_inherited_example.tscn","res://addons/BLV_Map_Editor/LevelPlaceholder_inherited_example_copied.tscn")
	
	editor.open_scene_from_path("res://addons/BLV_Map_Editor/LevelPlaceholder_inherited_example_copied.tscn")
	editor.set_main_screen_editor("2D")
	
	#Any other edits to the node can be done here
	var label = Label.new()
	label.name = "AAAAAAAAA"
	get_scene().add_child(label)
	label.set_owner(get_scene())
	
	editor.save_scene()
	
#	This didn't work
#	var new_level = load("res://addons/BLV_Map_Editor/LevelPlaceholder_inherited_example.tscn").instance()
#
#	var scene = PackedScene.new()
#
#	var result = scene.pack(new_level)
#	if result == OK:
#		var error = ResourceSaver.save("res://name.tscn", scene)
#		if error != OK:
#			print("An error occured")
#			print(error)
#	else:
#		print(result)
