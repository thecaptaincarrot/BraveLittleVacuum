extends Node

var PLAYER = null

var blow_force = 500
var suck_strength = 8
var hose_length = 8

var tank_size = 15

#booleans
#Nozzle
var accelerator = false
var railgun = false

#Chassis
var jump = true
var hover = true
var downhill = false

#Body
var waterproof = false
var armor = false
var power = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func upgrade(collected_upgrade):
	match collected_upgrade:
		"DEFAULT":
			print("Saw default upgrade. I probably shouldn't have if this wasn't a test")
		"HOSE LENGTH":
			hose_length += 5 #Adjust as needed
			PLAYER.regenerate_hose(hose_length)
		"JUMP":
			jump = true
