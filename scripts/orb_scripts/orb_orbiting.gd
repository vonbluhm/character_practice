extends OrbState
class_name OrbOrbiting


var orbiting_time: float
@export var orb_speed: int = 20
@export var orb_accel: int = 10


func enter():
	player = get_tree().get_first_node_in_group("player")
	orbiting_time = 0.0


func update(_delta):
	if Input.is_action_just_pressed("call") or Input.is_action_just_pressed("fire"):
		transitioned.emit(self, "OrbIntoHands")


func physics_update(delta):
	orbiting_time += delta
	var direction: Vector2 = (player.hands.global_position - orb.global_position)
	orb.velocity.x = roundi(move_toward(orb.velocity.x, direction.normalized().x * orb_speed, orb_accel))
	orb.velocity.y = roundi(move_toward(orb.velocity.y, direction.normalized().y * orb_speed + 4 * sin(orbiting_time), orb_accel))
	
	if direction.length() > 30:
		transitioned.emit(self, "OrbComingBack")
