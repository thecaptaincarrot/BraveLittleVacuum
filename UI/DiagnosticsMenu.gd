extends Control

var upgrade_selection = Vector2(0,0)
var selected_label

var active = false

enum {INFO, FLAVOR}
var mode = INFO
var old_mode = INFO

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
	information = "ERROR UPGRADE NOT INSTALLED.  PLEASE SEE YOUR LOCAL DEALERSHIP"
	match upgrade_selection:
		Vector2(0,0):
			new_selection = $NozzleUpgrades/MarginContainer/VBoxContainer/BasicSuck
			if mode == INFO:
				information = "Press RMB to suck objects into your tank\npresss LMB to shoot objects from your tank"
			elif mode == FLAVOR:
				information = "Sucks stuff up and spits it back out into the proper receptacle.\nWARNING! Objects are expelled at dangerous speeds!"
		Vector2(0,1):
			new_selection = $NozzleUpgrades/MarginContainer/VBoxContainer/PoweredEjection
			if Upgrades.accelerator:
				if mode == INFO:
					information = "Select the Nozzle with E or Q\nObjects fired will cause extra damage. Consumes Power."
				elif mode == FLAVOR:
					information = "An aftermarket Nozzle attachment with no real practical use, but very fun.\nWARNING! Objects expelled from the tank may be travelling at unwise speeds"
		Vector2(0,2):
			new_selection = $NozzleUpgrades/MarginContainer/VBoxContainer/Railgun
			if Upgrades.railgun:
				if mode == INFO:
					information = "Select the Nozzle with E or Q\nMust be charged up before firing by holding LMB.  Does a lot of extra damage and consumes power."
				elif mode == FLAVOR:
					information = "Originally designed with its military applications in mind before it was discovered that it was more economical to just build dedicated war robots than to repurpose household assistants."
		Vector2(0,3):
			new_selection = $NozzleUpgrades/MarginContainer/VBoxContainer/Label5
			information = "ERROR UPGRADE NOT INSTALLED.  PLEASE SEE YOUR LOCAL DEALERSHIP"
		Vector2(0,4):
			new_selection = $ChassiUpgrades/MarginContainer/VBoxContainer/AuxPower
			if Upgrades.power:
				if mode == INFO:
					information = "Provides power to special upgrades.\n1 Power Supply upgrade collected"
				elif mode == FLAVOR:
					information = "Provides high wattage, but limited, auxiliary power to modules that may be unable to run off the Suckmate stock Perpetual Power Supply"
		Vector2(0,5):
			new_selection = $ChassiUpgrades/MarginContainer/VBoxContainer/Waterproofing
			if Upgrades.waterproof:
				if mode == INFO:
					information = "Prevents damage from being submerged in water"
				elif mode == FLAVOR:
					information = "Great for areas prone to the recently more frequent storms and flooding.  Continue to clean even when under 20 feet of water!"
		Vector2(0,6):
			new_selection = $ChassiUpgrades/MarginContainer/VBoxContainer/Armor
			if Upgrades.armor:
				if mode == INFO:
					information = "Incoming damage is halved"
				elif mode == FLAVOR:
					information = "Made from an extremely resistant and durable polymer, bumps and scrapes that would normally damage the unit are instead effortlessly repelled.\nUnfortunately, even a small can of it costs as much as most houses."
		Vector2(1,3):
			new_selection = $WheelUpgrades/MarginContainer/VBoxContainer/LowFrictionCasters
			if mode == INFO:
				information = "Use the Arrow keys to move left and right"
			elif mode == FLAVOR:
				information = "Low-current brushless motors will keep your SuckMate effortlessly navigating your home for efficient cleaning"
		Vector2(1,4):
			new_selection = $WheelUpgrades/MarginContainer/VBoxContainer/SpringActuators
			if Upgrades.jump:
				if mode == INFO:
					information = "Press Space to jump"
				elif mode == FLAVOR:
					information = "Keep places that were once unreachable clean, saves a bundle by not having to buy an entirely SuckMate per floor of your hose.\nNot that many people can afford houses with more than one floor these days"
		Vector2(1,5):
			new_selection = $WheelUpgrades/MarginContainer/VBoxContainer/SpeedDelimiters
			if Upgrades.downhill:
				if mode == INFO:
					information = "When travelling downhill, pick up speed to damage enemies and break barriers."
				elif mode == FLAVOR:
					information = "During the skateboard shortage of '99, this popular black market mod allowed many hooligans to still shred using the most unlikely of vehicles.  Many fatalaties were reported."
		Vector2(1,6):
			new_selection = $WheelUpgrades/MarginContainer/VBoxContainer/HoverNozzles
			if Upgrades.hover:
				if mode == INFO:
					information = "Press Space when in the air to hover for a short time."
				elif mode == FLAVOR:
					information = "Placeholder hover nozzle flavor text"
	if (new_selection != selected_label and new_selection != null) or mode != old_mode:
		selected_label.get_node("SelectionRect").hide()
		new_selection.get_node("SelectionRect").show()
		selected_label = new_selection
		$InfoPanel.i = 0
		$InfoPanel.clear()
		$InfoPanel/Bubble.start()
		$InfoPanel.text = information
		match mode:
			INFO:
				$InfoPanel/MarginContainer/VBoxContainer/Title.text = "Information:"
			FLAVOR:
				$InfoPanel/MarginContainer/VBoxContainer/Title.text = "User Manual:"
		old_mode = mode


func _unhandled_input(event):
	if !visible:
		return
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
	elif event.is_action_pressed("ui_accept"):
		if mode == FLAVOR:
			mode = INFO
		elif mode == INFO:
			mode = FLAVOR

func refresh_upgrades():
	if Upgrades.accelerator:
		$NozzleUpgrades/MarginContainer/VBoxContainer/PoweredEjection.text = "Ejection Accelerator"
	if Upgrades.railgun:
		$NozzleUpgrades/MarginContainer/VBoxContainer/Railgun.text = "Magnetic Rail Ejector"
	if Upgrades.jump:
		$WheelUpgrades/MarginContainer/VBoxContainer/SpringActuators.text = "Spring Actuators"
	if Upgrades.downhill:
		$WheelUpgrades/MarginContainer/VBoxContainer/SpeedDelimiters.text = "Downhill Delimiters"
	if Upgrades.hover:
		$WheelUpgrades/MarginContainer/VBoxContainer/HoverNozzles.text = "Hover Jets"
	if Upgrades.waterproof:
		$ChassiUpgrades/MarginContainer/VBoxContainer/Waterproofing.text = "Waterproofing"
	if Upgrades.armor:
		$ChassiUpgrades/MarginContainer/VBoxContainer/Armor.text = "Dent-Resistant Paint"
	if Upgrades.power:
		$ChassiUpgrades/MarginContainer/VBoxContainer/AuxPower.text = "Peripheral Power Supply"
