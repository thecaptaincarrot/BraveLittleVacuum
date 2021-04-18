tool
extends AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	change_letter("_")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func change_letter(letter):
	var caps_leter = letter.capitalize()
	if letter == " ":
		hide()
		return
	
	match caps_leter:
		"A":
			frame = 0
		"B":
			frame = 1
		"C":
			frame = 2
		"D":
			frame = 3
		"E":
			frame = 4
		"F":
			frame = 5
		"G":
			frame = 6
		"H":
			frame = 7
		"I":
			frame = 8
		"J":
			frame = 9
		"K":
			frame = 10
		"L":
			frame = 11
		"M":
			frame = 12
		"N":
			frame = 13
		"O":
			frame = 14
		"P":
			frame = 15
		"Q":
			frame = 16
		"R":
			frame = 17
		"S":
			frame = 18
		"T":
			frame = 19
		"U":
			frame = 20
		"V":
			frame = 21
		"W":
			frame = 22
		"X":
			frame = 23
		"Y":
			frame = 24
		"Z":
			frame = 25
		"0":
			frame = 26
		"1":
			frame = 27
		"2":
			frame = 28
		"3":
			frame = 29
		"4":
			frame = 30
		"5":
			frame = 31
		"6":
			frame = 32
		"7":
			frame = 33
		"8":
			frame = 34
		"9":
			frame = 35
		"!":
			frame = 36
		"?":
			frame = 37
		"/":
			frame = 38
		"\\":
			frame = 38
		".":
			frame = 39
		":":
			frame = 40
		"_":
			frame = 41
		",":
			frame = 42
		"'":
			frame = 43
		'"':
			frame = 44

