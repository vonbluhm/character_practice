extends PlayerState
class_name PlayerBouncing

var touched_ground = false
var base_run_speed: float = 200.0
var run_accel: float = 10.0
var bounce_force: float = -600.0

func enter():
	touched_ground = false


func update(_delta):
	if orb.elemental_energy <= 0 or orb.energy <= 0:
		transitioned.emit(self, "PlayerDefault")


func physics_update(_delta):
	player.facing = player.set_facing()
	var out: Vector2 = player.velocity
	var x_axis: float = Input.get_axis("move_left", "move_right")
	out.x = roundi(move_toward(out.x, player.facing * abs(x_axis) * base_run_speed, run_accel))
	if Input.is_action_just_pressed("jump") or not touched_ground:
		out.y = player.max_fall_speed
	if player.is_on_floor():
		out.y = bounce_force
		touched_ground = true
		player.jump_hold_timer.start()
	elif player.is_on_ceiling():
		out.y = -bounce_force
		player.jump_hold_timer.stop()
	if player.jump_hold_timer.time_left > 0:
		if Input.is_action_pressed("jump"):
			out.y = bounce_force
		else:
			player.jump_hold_timer.stop()
			transitioned.emit(self, "PlayerDefault")
	else:
		out.y = player.apply_gravity(out)
	
	player.velocity = out
