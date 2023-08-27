extends CharacterBody2D
class_name Orb


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var FSM: Node = $FSM
@onready var elem_FSM: Node = $ElementsFSM
@onready var menu: Control = $RadialMenu
@onready var label = $Label
@onready var menu_buttons: Array = menu.get_children()
@onready var regular_hurtbox_shape = $HurtBox/CollisionShape2D
@onready var expanded_hurtbox_shape = $HurtBox/ExpandedColllisionShape
@onready var firing_ring = $FireSourceRing
var energy: float = 100.0
var max_energy: int = 200
var energy_change_rate: int = 5
@onready var elemental_power: ElementState = elem_FSM.initial_state
var elemental_energy: float
var max_elemental_energy: int = 200
var elem_energy_change_rate: int = -10
@onready var nonelem_bullet_scene: PackedScene = preload("res://scenes/non_elem_bullet.tscn")
@onready var water_bullet_scene: PackedScene = preload("res://scenes/water_bullet.tscn")
@onready var fire_bullet_scene: PackedScene = preload("res://scenes/fire_bullet.tscn")
@onready var air_bullet_scene: PackedScene = preload("res://scenes/air_bullet.tscn")
@onready var beam_scene: PackedScene = preload("res://scenes/beam.tscn")


func _ready():
	sprite.play("default")


func _process(delta):
	label.text = str(roundi(energy)) + "\n" + str(roundi(elemental_energy)) + "\n" + str(elem_FSM.current_state.name)
	energy += energy_change_rate * delta
	if energy > max_energy:
		energy = max_energy
	elif energy < 0:
		energy = 0
		elemental_energy = 0
	elemental_energy += elem_energy_change_rate * delta
	if elemental_energy > max_elemental_energy:
		elemental_energy = max_elemental_energy
	elif elemental_energy <= 0:
		elemental_energy = 0
	elemental_power = elem_FSM.current_state
	
	if FSM.current_state.name != "OrbExpanded":
		match elem_FSM.current_state.name:
			"ElementNone":
				sprite.play("default")
			"ElementWater":
				sprite.play("default_water")
			"ElementAir":
				sprite.play("default_air")
			"ElementCrystal":
				sprite.play("default_crystal")
			"ElementFire":
				sprite.play("default_fire")
	else:
		match elem_FSM.current_state.name:
			"ElementNone":
				sprite.play("expanded")
			"ElementWater":
				sprite.play("expanded_water")
			"ElementAir":
				sprite.play("expanded_air")
			"ElementCrystal":
				sprite.play("expanded_crystal")
			"ElementFire":
				sprite.play("expanded_fire")


func _physics_process(_delta):
	move_and_slide()
