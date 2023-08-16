extends CharacterBody2D
class_name Orb

enum ElementalPowers{
	NONE = 0,
	WATER = 1,
	AIR = 2,
	CRYSTAL = 3,
	FIRE = 4
}
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var FSM: Node = $FSM
@onready var menu: Control = $RadialMenu
@onready var menu_buttons: Array = menu.get_children()
var energy: float = 100.0
var max_energy: int = 200
var energy_change_rate: int = 5
var elemental_power: ElementalPowers = ElementalPowers.NONE
var elemental_energy: float
var max_elemental_energy: int
@onready var nonelem_bullet_scene: PackedScene = preload("res://scenes/non_elem_bullet.tscn")


func _ready():
	sprite.play("default")


func _process(delta):
	print(energy)
	energy += energy_change_rate * delta
	if energy > max_energy:
		energy = max_energy
	elif energy < 0:
		energy = 0


func _physics_process(_delta):
	move_and_slide()
