extends Node

var PLAYER = null

var blow_force = 500
var suck_strength = 5
var hose_length = 8

#booleans
var jump = true
var hover = true
var waterproof = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func upgrade(collected_upgrade):
	print(collected_upgrade)
	match collected_upgrade:
		"DEFAULT":
			print("Saw default upgrade. I probably shouldn't have if this wasn't a test")
		"HOSE LENGTH":
			print("hose length up")
			hose_length += 5 #Adjust as needed
			PLAYER.regenerate_hose(hose_length)
