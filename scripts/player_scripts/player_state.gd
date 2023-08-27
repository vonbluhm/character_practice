extends State
class_name PlayerState

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var orb: CharacterBody2D = get_tree().get_first_node_in_group("orb")

