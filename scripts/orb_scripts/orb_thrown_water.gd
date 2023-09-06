extends OrbState
class_name OrbThrownWater


var speed: int = 200
var accel: int = 600
var grav_accel: float = 50.0
var max_fall_speed: float = 800.0


func enter():
	orb.energy_change_rate = -10
	orb.velocity = player.facing * Vector2i(100, 0)
	orb.reparent(stage)


func update(_delta):
	if orb.energy <= 0:
		transitioned.emit(self, "OrbComingBack")
	if Input.is_action_just_pressed("call"):
		transitioned.emit(self, "OrbComingBack")
	if orb.elem_FSM.current_state.name != "ElementWater":
		transitioned.emit(self, "OrbComingBack")
	

func physics_update(delta):
	var out: Vector2 = orb.velocity
	var input_axis = Input.get_axis("ui_left", "ui_right")
	out.x = move_toward(out.x, out.x + 10 * input_axis * speed, accel * delta)
	out.y = move_toward(out.y, max_fall_speed, grav_accel)
	if orb.is_on_floor() or orb.is_on_ceiling():
		out.y = -out.y
	elif orb.is_on_wall():
		out = out.bounce(orb.get_wall_normal())
	orb.velocity = out
	
