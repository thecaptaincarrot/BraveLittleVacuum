extends Control

signal animation_finished

enum {DIAGNOSTICS, MAP, MAINMENU}

var open_menu = DIAGNOSTICS

#Upgrade menu stuff
var upgrade_selection = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_menu(new_menu):#new_menu is an enum
	pass


func open():
	#Check upgrades for diagnostics menu here
	hide_all()
	$AnimationPlayer.play("MenuOpen")
	match open_menu:
		DIAGNOSTICS:
			$MenuElements/DiagnosticsMenu.show()


func close():
	$AnimationPlayer.play("MenuClose")
	hide_all()


func  hide_all():
	for menu in $MenuElements.get_children():
		menu.hide()


