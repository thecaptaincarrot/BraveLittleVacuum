extends Node2D

const UPGRADE = preload("res://UI/Popup window.tscn")

var nozzle

var paused = false

var upgrade_on_deck = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Upgrades.PLAYER = $Player
	
	$Player.place_body($LevelHolder/Level0_0.get_entry(0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event.is_action_pressed("ui_pause"):
		if !get_tree().paused:
			pause()
		else:
			unpause()


func nozzle_shoot(body):
	var new_rock = SuckableObjects.decode_to_world(body).instance()
	new_rock.position = nozzle.global_position
	new_rock.collision_layer = 0
	new_rock.collision_mask = 5
	var vector = Vector2(cos(nozzle.rotation - PI/2),sin(nozzle.rotation - PI/2))
	$LevelHolder.get_child(0).get_node("Clutter").call_deferred("add_child",new_rock)
	new_rock.apply_central_impulse(vector * Upgrades.blow_force)


func menu_unpause():
	get_tree().paused = false
	if upgrade_on_deck != null:
		Upgrades.upgrade(upgrade_on_deck)
		upgrade_on_deck = null


func pause():
	$Overlay/InGameMenus.pause_mode = Node.PAUSE_MODE_STOP
	get_tree().paused = true
	$Overlay/UI/Pause.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func unpause():
	$Overlay/InGameMenus.pause_mode = Node.PAUSE_MODE_PROCESS
	if !paused:
		get_tree().paused = false
	$Overlay/UI/Pause.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_UpgradeSphere_upgrade_collected(upgrade):
	pass # Replace with function body.
	#1. pause
	paused = true #The game should not be unpaused if a menu is opened
				  #Realistically, do not allow them to open the system menu at this stage
	get_tree().paused = true
	#2. open menu
	var new_window = UPGRADE.instance()
	new_window.connect("menu_unpause",self,"menu_unpause")
	new_window.connect("menu_unpause",$Player/PlayerBody,"menu_unpause")
	$Overlay/InGameMenus.add_child(new_window)
	upgrade_on_deck = upgrade