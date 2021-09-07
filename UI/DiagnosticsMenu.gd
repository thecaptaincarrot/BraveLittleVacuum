extends Control

var upgrade_selection = Vector2(0,0)
var selected_label

var active = false

signal next
signal previous


# Called when the node enters the scene tree for the first time.
func _ready():
	selected_label = $NozzleUpgrades/MarginContainer/VBoxContainer/BasicSuck
	upgrade_selection = Vector2(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !visible:
		return
	var information
	var new_selection
	match upgrade_selection:
		Vector2(0,0):
			new_selection = $NozzleUpgrades/MarginContainer/VBoxContainer/BasicSuck
			information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
		Vector2(0,1):
			new_selection = $NozzleUpgrades/MarginContainer/VBoxContainer/PoweredEjection
			information = "Overcharges the Ejection System, allowing objects to be expelled at dangerous speeds. Consumes power."
		Vector2(0,2):
			new_selection = $NozzleUpgrades/MarginContainer/VBoxContainer/Railgun
			information = "Objects fired from the railgun attachment travel so fast as to be nearly immune to gravity."
		Vector2(0,3):
			new_selection = $NozzleUpgrades/MarginContainer/VBoxContainer/Label5
			information = "ERROR UPGRADE NOT INSTALLED.  PLEASE SEE YOUR LOCAL DEALERSHIP"
		Vector2(0,4):
			new_selection = $ChassiUpgrades/MarginContainer/VBoxContainer/AuxPower
			information = "Provides additional power to specialized attachments. Must be recharged after prolonged use."
		Vector2(0,5):
			new_selection = $ChassiUpgrades/MarginContainer/VBoxContainer/Waterproofing
			information = "Insulates all vulnerable electrical components against water damage, making the vacuum fully submersible"
		Vector2(0,6):
			new_selection = $ChassiUpgrades/MarginContainer/VBoxContainer/Armor
			information = "For heavy duty applications, makes the vacuum twice as resistant to damage"
		Vector2(1,3):
			new_selection = $WheelUpgrades/MarginContainer/VBoxContainer/LowFrictionCasters
			information = "Standard nearly lossless wheels allow unfettered mobility in any environment or terrain"
		Vector2(1,4):
			new_selection = $WheelUpgrades/MarginContainer/VBoxContainer/SpringActuators
			information = "Clean in hard to reach places by pressing SPACE to leap into the air"
		Vector2(1,5):
			new_selection = $WheelUpgrades/MarginContainer/VBoxContainer/SpeedDelimiters
			information = "An aftermarket attachment that stops the auto-brakes from engaging on downhill slopes. Can break through walls and enemies"
		Vector2(1,6):
			new_selection = $WheelUpgrades/MarginContainer/VBoxContainer/HoverNozzles
			information = "Press SPACEBAR while in the air to hover for a short distance"
	if new_selection != selected_label and new_selection != null:
		selected_label.get_node("SelectionRect").hide()
		new_selection.get_node("SelectionRect").show()
		selected_label = new_selection
		$InfoPanel.i = 0
		$InfoPanel.clear()
		$InfoPanel/Bubble.start()
		$InfoPanel.text = information


func _unhandled_input(event):
	if !visible:
		return
	print("diagnostic input detected")
	if event.is_action_pressed("ui_down"):
		upgrade_selection.y += 1
		if upgrade_selection == Vector2(0,7):
			upgrade_selection = Vector2(0,0)
		elif upgrade_selection == Vector2(1,7):
			upgrade_selection = Vector2(1,3)
	elif event.is_action_pressed("ui_up"):
		upgrade_selection.y -= 1
		if upgrade_selection == Vector2(0,-1):
			upgrade_selection = Vector2(0,6)
		elif upgrade_selection == Vector2(1,2):
			upgrade_selection = Vector2(1,6)
	elif event.is_action_pressed("ui_left"):
		if upgrade_selection.x == 0:
			pass
			#go left on the menu
		else: upgrade_selection.x = 0
	elif event.is_action_pressed("ui_right"):
		if upgrade_selection.x == 1:
			emit_signal("next")
		else: 
			upgrade_selection.x = 1
			if upgrade_selection.y < 3:
				upgrade_selection.y = 3
