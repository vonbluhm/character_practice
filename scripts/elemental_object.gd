extends Area2D

enum Element{
	WATER,
	AIR,
	CRYSTAL,
	FIRE
}
@export var element: Element = Element.WATER
@onready var sprite = $AnimatedSprite2D

func _ready():
	add_to_group("elemental_objects")
	match element:
		Element.WATER:
			sprite.play("water")
			add_to_group("water_sources")
		Element.AIR:
			sprite.play("air")
			add_to_group("air_sources")
		Element.CRYSTAL:
			sprite.play("crystal")
			add_to_group("crystal_sources")
		Element.FIRE:
			sprite.play("fire")
			add_to_group("fire_sources")
