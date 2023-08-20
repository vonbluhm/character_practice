extends State
class_name OrbState

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var stage: Node2D = get_tree().get_first_node_in_group("stage")
@export var orb: CharacterBody2D


func enter():
	pass


func exit():
	pass


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass
