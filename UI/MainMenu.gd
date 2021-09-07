extends Control

signal animation_finished

enum {DIAGNOSTICS, MAP, SYSTEM}

var open_menu = DIAGNOSTICS

#Upgrade menu stuff
var upgrade_selection = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	if event.is_action_pressed("ui_next"):
		match open_menu:
			DIAGNOSTICS:
				go_to_map()
			MAP:
				go_to_system()
			SYSTEM:
				go_to_diagnostics()
	elif event.is_action_pressed("ui_previous"):
		match open_menu:
			DIAGNOSTICS:
				go_to_system()
			MAP:
				go_to_diagnostics()
			SYSTEM:
				go_to_map()

func change_menu(new_menu):#new_menu is an enum
	pass


func open():
	#Check upgrades for diagnostics menu here
	hide_all()
	$AnimationPlayer.play("MenuOpen")
	match open_menu:
		DIAGNOSTICS:
			$MenuElements/DiagnosticsMenu.show()
			$MenuElements/DiagnosticsMenu.active = true
		MAP:
			$MenuElements/MapMenu.show()
			$MenuElements/MapMenu.active = true
		SYSTEM:
			$MenuElements/SystemMenu.show()
			$MenuElements/SystemMenu.active = true


func open_system_menu():
	open_menu = SYSTEM
	open()


func open_diagnostics_menu():
	open_menu = DIAGNOSTICS
	open()


func close():
	$AnimationPlayer.play("MenuClose")
	hide_all()


func  hide_all():
	for menu in $MenuElements.get_children():
		menu.hide()
		menu.active = false
		print(menu.visible)


func go_to_diagnostics():
	print("go_to_diadnostics")
	hide_all()
	open_menu = DIAGNOSTICS
	$MenuElements/DiagnosticsMenu.show()
	if not get_tree():
	   return


func go_to_system():
	print("go to system")
	hide_all()
	open_menu = SYSTEM
	$MenuElements/SystemMenu.show()
	if not get_tree():
	   return


func go_to_map():
	print("go to map")
	hide_all()
	open_menu = MAP
	$MenuElements/MapMenu.show()
	if not get_tree():
	   return
