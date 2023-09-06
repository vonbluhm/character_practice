extends OrbState
class_name OrbInHands


var input_buffer_timer: Timer
var effective_vector: Vector2 = Vector2.ZERO


func enter():
	orb.energy_change_rate = 10
	player = get_tree().get_first_node_in_group("player")
	orb.global_position = player.hands.global_position
	orb.velocity = Vector2.ZERO
	player.hands.progress_ratio = 0.25 * (1 - player.facing)
	if Input.is_action_pressed("call"):
		reveal_menu()


func update(_delta):
	orb.global_position = player.hands.global_position
	if Input.is_action_just_pressed("call"):
		reveal_menu()
	if Input.is_action_pressed("fire"):
		transitioned.emit(self, "OrbHeld")
	
	var input_vector = Input.get_vector("move_left", "move_right", "aim_up", "aim_down")
	if input_vector != Vector2.ZERO:
		effective_vector = input_vector
		if input_buffer_timer:
			input_buffer_timer.start()
	elif !input_buffer_timer:
		input_buffer_timer = Timer.new()
		input_buffer_timer.wait_time = 0.2
		input_buffer_timer.autostart = true
		input_buffer_timer.one_shot = true
		input_buffer_timer.timeout.connect(_on_timeout)
		add_child(input_buffer_timer)
		
	if effective_vector.x != 0:
		if effective_vector.x < 0:
			orb.menu_buttons[1].grab_focus()
			if Input.is_action_just_released("call"):
				transitioned.emit(self, "OrbExpanded")
		elif effective_vector.x > 0:
			orb.menu_buttons[3].grab_focus()
			if Input.is_action_just_released("call"):
				match orb.elem_FSM.current_state.name:
					"ElementNone":
						transitioned.emit(self, "OrbRC")
					"ElementWater":
						transitioned.emit(self, "OrbThrownWater")
					"ElementAir":
						transitioned.emit(self, "OrbThrownAir")
					"ElementCrystal":
						transitioned.emit(self, "OrbThrownCrystal")
					"ElementFire":
						transitioned.emit(self, "OrbThrownFire")
	elif effective_vector.y != 0:
		if effective_vector.y < 0:
			orb.menu_buttons[2].grab_focus()
			if Input.is_action_just_released("call"):
				transitioned.emit(self, "OrbOrbiting")
		elif effective_vector.y > 0:
			orb.menu_buttons[4].grab_focus()
			if Input.is_action_just_released("call"):
				transitioned.emit(self, "OrbHugged")
	else:
		orb.menu_buttons[0].grab_focus()
		if Input.is_action_just_released("call"):
			transitioned.emit(self, "OrbOrbiting")
	
		
func exit():
	orb.menu.hide()


func reveal_menu():
	orb.rotation = 0
	orb.menu.rotation = 0
	orb.menu.show()
	orb.menu_buttons[0].grab_focus()


func _on_timeout():
	effective_vector = Vector2.ZERO
	input_buffer_timer.stop()
