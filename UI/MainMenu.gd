extends Control

signal animation_finished

enum {DIAGNOSTICS, MAP, SYSTEM}

var open_menu = DIAGNOSTICS

var outside_tween
var color_tween

#Upgrade menu stuff
var upgrade_selection = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	outside_tween = $OutsideRectTween
	color_tween = $ColorRectTween


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
	$MenuElements/DiagnosticsMenu.refresh_upgrades()
	var screen_size = get_viewport().size
	
	outside_tween.remove_all()
	color_tween.remove_all()
	
	outside_tween.interpolate_property($OutsideRect,"rect_position",Vector2(-20,-74),Vector2(0,0),0.75)
	outside_tween.interpolate_property($OutsideRect,"rect_size",Vector2(screen_size.x + 40,screen_size.y + 97),screen_size,0.75)
	
	color_tween.interpolate_property($ColorRect,"rect_position",Vector2(screen_size.x / 2,screen_size.y / 2 - 8),Vector2(0,screen_size.y / 2 - 8),0.25)
	color_tween.interpolate_property($ColorRect,"rect_size",Vector2(0,16),Vector2(screen_size.x,16),0.25)
	
	outside_tween.start()
	color_tween.start()
	
	yield(color_tween, "tween_all_completed")
	color_tween.remove_all()
	
	color_tween.interpolate_property($ColorRect,"rect_position",Vector2(0,screen_size.y / 2 - 8),Vector2(0,0),0.5)
	color_tween.interpolate_property($ColorRect,"rect_size",Vector2(screen_size.x,16),screen_size,0.5)
	
	color_tween.start()
	yield(color_tween, "tween_all_completed")
	
	match open_menu:
		DIAGNOSTICS:
			print("Ugh")
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
	hide_all()
	$MenuElements/DiagnosticsMenu.refresh_upgrades()
	var screen_size = get_viewport().size
	
	outside_tween.remove_all()
	color_tween.remove_all()
	print(screen_size)
	
	outside_tween.interpolate_property($OutsideRect,"rect_position",Vector2(0,0),Vector2(-20,-74),0.75)
	outside_tween.interpolate_property($OutsideRect,"rect_size",screen_size,Vector2(screen_size.x + 40,screen_size.y + 97),0.75)
	
	color_tween.interpolate_property($ColorRect,"rect_position",Vector2(0,0),Vector2(0,screen_size.y / 2 - 8),0.5)
	color_tween.interpolate_property($ColorRect,"rect_size",screen_size,Vector2(screen_size.x,16),0.5)
	
	outside_tween.start()
	color_tween.start()
	
	yield(color_tween, "tween_all_completed")
	color_tween.remove_all()
	
	color_tween.interpolate_property($ColorRect,"rect_position",Vector2(0,screen_size.y / 2 - 8),Vector2(screen_size.x / 2,screen_size.y / 2 - 8),0.25)
	color_tween.interpolate_property($ColorRect,"rect_size",Vector2(screen_size.x,16),Vector2(0,16),0.25)
	
	color_tween.start()
	
	yield(color_tween, "tween_all_completed")
	emit_signal("animation_finished")


func  hide_all():
	for menu in $MenuElements.get_children():
		menu.hide()
		menu.active = false


func go_to_diagnostics():
	hide_all()
	open_menu = DIAGNOSTICS
	$MenuElements/DiagnosticsMenu.show()
	if not get_tree():
	   return


func go_to_system():
	hide_all()
	open_menu = SYSTEM
	$MenuElements/SystemMenu.show()
	if not get_tree():
	   return


func go_to_map():
	hide_all()
	open_menu = MAP
	$MenuElements/MapMenu.show()
	if not get_tree():
	   return
