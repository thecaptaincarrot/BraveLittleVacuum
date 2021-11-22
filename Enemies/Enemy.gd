extends KinematicBody2D

enum {DEFAULT}

export var health = 1
export var collision_damage = 5.0

var motion = Vector2(0,0)
var state = DEFAULT

var overlapping_enemies = []
var overlap_unstick_multiplier = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#moving and sliding is done deeper
	unstick()


func collision(body,collision_speed):
	if body.damaging:
		var damage = 1 #needs to be changed probs
		hurt(damage)
		if health <= 0.0:
			die()
			


func unstick():
	for overlap_hitbox in overlapping_enemies:
		motion -= (overlap_hitbox.global_position - $Hitboxes/UnstickArea.global_position) * overlap_unstick_multiplier


func disable_unstick():
	$Hitboxes/UnstickArea.monitoring = false
	overlapping_enemies.clear()


func die():
	pass

func hurt(damage):
	health -= damage


func _on_UnstickArea_area_entered(area):
	overlapping_enemies.append(area)


func _on_UnstickArea_area_exited(area):
	overlapping_enemies.erase(area)
