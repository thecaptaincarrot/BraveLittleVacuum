tool
extends Node2D

export (PackedScene) var Letter

export var word : String

var current_word = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_word != word:
		current_word = word
		var wordlength = len(current_word)
		for N in $LettersContainer.get_children():
			N.queue_free()
		for i in range (0,wordlength):
			var new_letter = Letter.instance()
			var letter = current_word[i]
			
			$LettersContainer.add_child(new_letter)
			
			new_letter.change_letter(letter)
			
			new_letter.position.x += 22 * i
		
		center_up(wordlength)
		


func center_up(wordlength):
	var x_position = -(wordlength * 22) / 2 + 11
	$LettersContainer.position.x = x_position

