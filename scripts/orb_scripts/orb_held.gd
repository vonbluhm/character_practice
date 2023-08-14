extends OrbState
class_name OrbHeld


func enter():
	orb.reparent(player)


func update(_delta):
	if Input.is_action_just_pressed("call"):
		transitioned.emit(self, "OrbInHands")
