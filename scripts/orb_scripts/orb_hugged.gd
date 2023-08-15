extends OrbState
class_name OrbHugged

var recharge_rate: int = 50


func enter():
	orb.self_modulate = Color(1.5, 1, 1, 1)


func exit():
	orb.self_modulate = Color(1, 1, 1, 1)


func update(delta):
	orb.energy += recharge_rate * delta
	if orb.energy >= orb.max_energy:
		transitioned.emit(self, "OrbOrbiting")
