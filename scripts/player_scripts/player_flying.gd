extends PlayerState
class_name PlayerFlying

var base_flight_speed: float = 200.0
var run_accel: float = 10.0
var jump_released


func enter():
	jump_released = false


func update(_delta):
	if Input.is_action_just_released("jump"):
		jump_released = true
	if Input.is_action_just_pressed("jump") and jump_released:
		transitioned.emit(self, "PlayerDefault")
	if Input.is_action_just_pressed("call") and not Input.is_action_pressed("fire"):
		transitioned.emit(self, "PlayerDefault")
	if orb.elemental_energy <= 0 or orb.energy <= 0:
		transitioned.emit(self, "PlayerDefault")
	if player.is_on_ground():
		transitioned.emit(self, "PlayerDefault")


func physics_update(_delta):
	if not player.is_movement_halted():
		player.facing = player.set_facing()
		var input_vector = Input.get_vector("move_left", "move_right", "aim_up", "aim_down")
		if input_vector.length() > 1:
			input_vector = input_vector.normalized()
		var out = player.velocity
		out.x = roundi(move_toward(out.x, input_vector.x * base_flight_speed, run_accel))
		out.y = roundi(move_toward(out.y, input_vector.y * base_flight_speed, run_accel))
		player.velocity = out
