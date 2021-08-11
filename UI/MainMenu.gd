extends Control

signal animation_finished

enum {DIAGNOSTICS}

var open_menu = DIAGNOSTICS

#Upgrade menu stuff
var upgrade_selection = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match open_menu:
		DIAGNOSTICS:
			var selected_label
			var information
			match upgrade_selection:
				Vector2(0,0):
					selected_label = $MenuElements/UpgradeMenu/NozzleUpgrades/MarginContainer/VBoxContainer/BasicSuck
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(0,1):
					selected_label = $MenuElements/UpgradeMenu/NozzleUpgrades/MarginContainer/VBoxContainer/PoweredEjection
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(0,2):
					selected_label = $MenuElements/UpgradeMenu/NozzleUpgrades/MarginContainer/VBoxContainer/Railgun
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(0,3):
					selected_label = $MenuElements/UpgradeMenu/NozzleUpgrades/MarginContainer/VBoxContainer/Label5
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(0,4):
					selected_label = $MenuElements/UpgradeMenu/ChassiUpgrades/MarginContainer/VBoxContainer/AuxPower
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(0,5):
					selected_label = $MenuElements/UpgradeMenu/ChassiUpgrades/MarginContainer/VBoxContainer/Waterproofing
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(0,6):
					selected_label = $MenuElements/UpgradeMenu/ChassiUpgrades/MarginContainer/VBoxContainer/Armor
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(1,4):
					selected_label = $MenuElements/UpgradeMenu/WheelUpgrades/MarginContainer/VBoxContainer/LowFrictionCasters
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(1,5):
					selected_label = $MenuElements/UpgradeMenu/WheelUpgrades/MarginContainer/VBoxContainer/SpringActuators
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(1,6):
					selected_label = $MenuElements/UpgradeMenu/WheelUpgrades/MarginContainer/VBoxContainer/SpeedDelimiters
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."
				Vector2(1,7):
					selected_label = $MenuElements/UpgradeMenu/WheelUpgrades/MarginContainer/VBoxContainer/HoverNozzles
					information = "Stock vacuum suction motor. Right Click to suck objects into your tank and left click to fire them out."

			pass


func open():
	#Check upgrades for diagnostics menu here
	$AnimationPlayer.play("MenuOpen")


func close():
	$AnimationPlayer.play("MenuClose")
