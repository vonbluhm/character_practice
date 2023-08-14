extends OrbState
class_name OrbComingBack

var state_time: float
@export var orb_speed: int = 100
@export var orb_accel: int = 50


func enter():
	player = get_tree().get_first_node_in_group("player")
	state_time = 0.0


func update(_delta):
	if Input.is_action_just_pressed("call") or Input.is_action_just_pressed("fire"):
		transitioned.emit(self, "OrbIntoHands")


func physics_update(delta):
	state_time += delta
	var direction: Vector2 = (player.hands.global_position - orb.global_position)
	if direction.length() >= 2:
		orb.velocity.x = roundi(move_toward(orb.velocity.x, direction.normalized().x * orb_speed, orb_accel))
		orb.velocity.y = roundi(move_toward(orb.velocity.y, direction.normalized().y * orb_speed, orb_accel))
		orb.velocity.y += 25 * sin(5 * state_time)
	else:
		orb.velocity = Vector2.ZERO
		transitioned.emit(self, "OrbOrbiting")
