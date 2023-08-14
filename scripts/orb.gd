extends CharacterBody2D
class_name Orb

@onready var FSM = $FSM

func _physics_process(_delta):
	move_and_slide()
