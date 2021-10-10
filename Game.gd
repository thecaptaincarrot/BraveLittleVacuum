extends Node2D

const UPGRADE = preload("res://UI/Popup window.tscn")

var level_path = "res://World/Levels/Level"
var current_level = null
var current_levelcode = 0

var player
var nozzle

var paused = false
var upgrade_paused = false

var upgrade_on_deck = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	Upgrades.PLAYER = $Player
	Globals.PLAYER = $Player
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event.is_action_pressed("ui_pause"):
		if !upgrade_paused:
			if !get_tree().paused:
				system_pause()
			else:
				mainmenu_unpause()
	if event.is_action_pressed("ui_gamemenu"):
		if !upgrade_paused:
			if !get_tree().paused:
				mainmenu_pause()
			else:
				mainmenu_unpause()


func nozzle_shoot(body):
	var new_rock = SuckableObjects.decode_to_world(body).instance()
	new_rock.position = nozzle.global_position
	new_rock.collision_layer = 8
	new_rock.collision_mask = 5
	new_rock.damaging = true
	var vector = Vector2(cos(nozzle.rotation - PI/2),sin(nozzle.rotation - PI/2))
	$LevelHolder.get_child(0).get_node("Clutter").call_deferred("add_child",new_rock)
	new_rock.apply_central_impulse(vector * Upgrades.blow_force)


func new_game():
	player.deactivate()
	$Overlay/ColorOverlay.fadeout = true
	goto_new_level(0,0)
#	current_level = add_level(0)
#	player.place_body(current_level.get_entry(0))
	$Overlay/ColorOverlay.fadeout = false
	player.activate()


func goto_new_level(levelcode, exit : int):
	print("Level Code: ", levelcode)
	player.deactivate()
	$Overlay/ColorOverlay.fadeout = true
	yield(get_tree().create_timer(0.5), "timeout")
	var new_level = null
	if current_level:
		current_level.queue_free()
		current_level = null
	if LevelDecoder.level_dict.has(levelcode):
		new_level = add_level(levelcode)
		current_level = new_level
		current_levelcode = levelcode
	else:
		print("***ERROR TRIED TO GO TO INVALID LEVEL ",levelcode,"***")
		new_level = add_level(0)
		current_level = new_level
		current_levelcode = 0
	print("went to new level: ",current_level.name)
	
	var exit_obj = new_level.get_exit(exit)
	exit_obj.active = false
	#Camera stuff
	var bounding_box_pos = current_level.get_camera_bounds()[0]
	var bounding_box_size = current_level.get_camera_bounds()[1]
	
	player.camera.limit_left = bounding_box_pos.x
	player.camera.limit_right = bounding_box_pos.x + bounding_box_size.x
	player.camera.limit_top = bounding_box_pos.y
	player.camera.limit_bottom = bounding_box_pos.y + bounding_box_size.y
	#Palyer stuff
	player.place_body(exit_obj.global_position)
	player.body.inactive = true
	yield(get_tree().create_timer(0.5),"timeout")
	player.body.inactive = false
	$Overlay/ColorOverlay.fadeout = false


func add_level(levelcode):
	var new_level_path = LevelDecoder.level_dict[levelcode]
	var new_level = load(new_level_path).instance()
	for N in new_level.get_exits():
		N.connect("level_exit",self,"goto_new_level")
	for Upgrade in new_level.get_upgrades():
		Upgrade.connect("upgrade_collected",self, "collect_upgrade")
		Upgrade.check_upgrade()
		
	$LevelHolder.add_child(new_level)
	return new_level


func menu_unpause():
	get_tree().paused = false
	upgrade_paused = false
	if upgrade_on_deck != null:
		Upgrades.upgrade(upgrade_on_deck)
		upgrade_on_deck = null


func mainmenu_pause():
	$Overlay/InGameMenus/MainMenu.open()
	player.hide_UI()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func mainmenu_unpause():
	$Overlay/InGameMenus/MainMenu.close()
#	player.show_UI() #done by signal


func system_pause(): #This will obsolete when menu is fleshed out
	$Overlay/InGameMenus/MainMenu.open_system_menu()
	player.hide_UI()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func collect_upgrade(upgrade):
	pass # Replace with function body.
	#1. pause
	upgrade_paused = true #The game should not be unpaused if a menu is opened
				  #Realistically, do not allow them to open the system menu at this stage
	get_tree().paused = true
	#2. open menu
	var new_window = UPGRADE.instance()
	new_window.connect("menu_unpause",self,"menu_unpause")
	new_window.connect("menu_unpause",$Player/PlayerBody,"menu_unpause")
	$Overlay/InGameMenus.add_child(new_window)
	upgrade_on_deck = upgrade


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "MenuClose":
			if !paused:
				get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
