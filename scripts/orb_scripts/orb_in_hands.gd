extends OrbState
class_name OrbInHands


func enter():
	player = get_tree().get_first_node_in_group("player")
	orb.global_position = player.hands.global_position
	orb.velocity = Vector2.ZERO


func update(_delta):
	if Input.is_action_just_released("call"):
		transitioned.emit(self, "OrbOrbiting")
	if Input.is_action_pressed("fire"):
		transitioned.emit(self, "OrbHeld")
