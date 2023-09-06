extends OrbState
class_name OrbThrownCrystal


var speed: int = 200
var accel: int = 600


func enter():
	orb.energy_change_rate = -10
	orb.velocity = player.facing * Vector2i(10, 0)
	orb.reparent(stage)
	player.collision_mask += 4


func update(_delta):
	if orb.energy <= 0:
		transitioned.emit(self, "OrbComingBack")
	if Input.is_action_just_pressed("call"):
		transitioned.emit(self, "OrbComingBack")
	if orb.elem_FSM.current_state.name != "ElementCrystal":
		transitioned.emit(self, "OrbComingBack")
	

func physics_update(delta):
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()
	orb.velocity.x = move_toward(orb.velocity.x, input_vector.x * speed, accel * delta)
	orb.velocity.y = move_toward(orb.velocity.y, input_vector.y * speed, accel * delta)


func exit():
	player.collision_mask -= 4
