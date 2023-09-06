extends OrbState
class_name OrbThrownFire


var speed: int = 300
var accel: int = 300


func enter():
	orb.energy_change_rate = -10
	orb.velocity = player.facing * Vector2i(speed, 0)
	orb.reparent(stage)


func update(_delta):
	if orb.energy <= 0:
		transitioned.emit(self, "OrbComingBack")
	if Input.is_action_just_pressed("call"):
		transitioned.emit(self, "OrbComingBack")
	if orb.elem_FSM.current_state.name != "ElementFire":
		transitioned.emit(self, "OrbComingBack")
	

func physics_update(delta):
	var out = orb.velocity
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()
	out.x = move_toward(out.x, out.x + input_vector.x * 10, accel * delta)
	out.y = move_toward(out.y, out.y + input_vector.y * 10, accel * delta)
	out = out.normalized() * speed
	orb.velocity = out
	
	if orb.is_on_wall() or orb.is_on_ceiling() or orb.is_on_floor():
		transitioned.emit(self, "OrbComingBack")
	
