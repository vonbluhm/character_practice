extends CharacterBody2D
class_name Orb

enum ElementalPowers{
	NONE = 0,
	WATER = 1,
	AIR = 2,
	CRYSTAL = 3,
	FIRE = 4
}
@onready var FSM: Node = $FSM
@onready var menu: Control = $RadialMenu
@onready var menu_buttons: Array = menu.get_children()
var energy = 100
var max_energy = 200
var elemental_power: ElementalPowers = ElementalPowers.NONE
var elemental_energy
@onready var nonelem_bullet_scene: PackedScene = preload("res://scenes/non_elem_bullet.tscn")


func _process(_delta):
	if energy > max_energy:
		energy = max_energy
	elif energy < 0:
		energy = 0


func _physics_process(_delta):
	move_and_slide()
