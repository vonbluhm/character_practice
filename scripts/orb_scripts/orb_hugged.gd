extends OrbState
class_name OrbHugged


func enter():
	orb.energy_change_rate = 50
	orb.sprite.modulate = Color(1.5, 0.5, 0.5, 1)


func exit():
	orb.sprite.modulate = Color(1, 1, 1, 1)


func update(_delta):
	if orb.energy >= orb.max_energy:
		transitioned.emit(self, "OrbOrbiting")
