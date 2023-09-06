extends OrbState
class_name OrbThrownAir

var speed: int = 200
var accel: int = 600
var vert_accel: float = 50.0
var float_speed: float = -100.0


func enter():
	orb.energy_change_rate = -10
	orb.velocity.x = player.facing * 100
	orb.velocity.y = float_speed
	orb.reparent(stage)
	
	
func update(_delta):
	if orb.energy <= 0:
		transitioned.emit(self, "OrbComingBack")
	if Input.is_action_just_pressed("call"):
		transitioned.emit(self, "OrbComingBack")
	if orb.elem_FSM.current_state.name != "ElementAir":
		transitioned.emit(self, "OrbComingBack")
	
	
func physics_update(delta):
	var out: Vector2 = orb.velocity
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	out.x = move_toward(out.x, input_vector.x * speed, accel * delta)
	out.y = move_toward(out.y, float_speed * (1 - 0.5 * input_vector.y) , vert_accel)
	if orb.is_on_ceiling():
		transitioned.emit(self, "OrbComingBack")
	orb.velocity = out
