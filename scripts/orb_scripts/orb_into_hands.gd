extends OrbState
class_name OrbIntoHands


@export var orb_speed: int = 300
@export var orb_accel: int = 50


func enter():
	player = get_tree().get_first_node_in_group("player")


func exit():
	pass


func update(_delta):
	if Input.is_action_just_released("call") and not Input.is_action_pressed("fire") or Input.is_action_just_released("fire") and not Input.is_action_pressed("call"):
		transitioned.emit(self, "OrbComingBack")


func physics_update(_delta):
	var direction: Vector2 = (player.hands.global_position - orb.global_position)
	if direction.length() >= 10:
		orb.velocity.x = roundi(move_toward(orb.velocity.x, direction.normalized().x * orb_speed, orb_accel))
		orb.velocity.y = roundi(move_toward(orb.velocity.y, direction.normalized().y * orb_speed, orb_accel))
	else:
		orb.global_position = player.hands.global_position
		orb.velocity = Vector2.ZERO
		transitioned.emit(self, "OrbInHands")
