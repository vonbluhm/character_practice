extends PlayerState
class_name PlayerRolling

var base_run_speed: float = 500.0
var run_accel: float = 12.0
var jump_force = -300
var facing

func enter():
	facing = player.set_facing()


func physics_update(delta):
	if not player.is_movement_halted():
		player.velocity = get_linear_velocity(delta)
	else:
		player.velocity.x = 0.0
		player.velocity.y = player.apply_gravity(player.velocity)
	if player.is_on_wall():
		transitioned.emit(self, "PlayerDefault")


func get_linear_velocity(_delta):
	var out: Vector2 = player.velocity
	var x_axis: float = Input.get_axis("move_left", "move_right")
	out.x = roundi(move_toward(out.x, facing * base_run_speed, run_accel))
	out.y = player.apply_gravity(out)
	out.y = listen_to_jump_input(out.y)
	return out


func listen_to_jump_input(y: float):
	#Checks if the jump button is pressed and changes vertical velocity accordingly
	if player.jump_hold_timer.is_stopped() and Input.is_action_just_pressed("jump"):
		if player.is_on_ground() and not Input.is_action_pressed("aim_down"):
			y = jump_force
			player.jump_hold_timer.start()
	elif player.jump_hold_timer.time_left > 0:
		if Input.is_action_pressed("jump"):
			y = jump_force
		else:
			player.jump_hold_timer.stop()
	return roundi(y)
