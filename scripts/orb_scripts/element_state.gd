extends State
class_name ElementState

@export var orb: CharacterBody2D



func enter():
	orb.elemental_energy = 0


func update(_delta):
	if orb.elemental_energy <= 0 and orb.elemental_power.name != "ElementNone":
		transitioned.emit(self, "ElementNone")


