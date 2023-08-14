extends CharacterBody2D
class_name Orb

@onready var FSM = $FSM
var orb_energy
var elemental_power: int = 0
var elemental_energy

func _physics_process(_delta):
	move_and_slide()
