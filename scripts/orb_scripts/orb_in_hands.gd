extends OrbState
class_name OrbInHands


func enter():
	orb.energy_change_rate = 10
	player = get_tree().get_first_node_in_group("player")
	orb.global_position = player.fire_source.global_position
	orb.velocity = Vector2.ZERO
	if Input.is_action_pressed("call"):
		reveal_menu()


func update(_delta):
	if Input.is_action_just_pressed("call"):
		reveal_menu()
	if Input.is_action_pressed("fire"):
		transitioned.emit(self, "OrbHeld")
	
	
	var input_vector = Input.get_vector("move_left", "move_right", "aim_up", "aim_down")
	if input_vector.x != 0:
		if input_vector.x < 0:
			orb.menu_buttons[1].grab_focus()
			if Input.is_action_just_released("call"):
				transitioned.emit(self, "OrbExpanded")
		elif input_vector.x > 0:
			orb.menu_buttons[3].grab_focus()
			if Input.is_action_just_released("call"):
				transitioned.emit(self, "OrbRC")
	elif input_vector.y != 0:
		if input_vector.y < 0:
			orb.menu_buttons[2].grab_focus()
			if Input.is_action_just_released("call"):
				transitioned.emit(self, "OrbOrbiting")
		elif input_vector.y > 0:
			orb.menu_buttons[4].grab_focus()
			if Input.is_action_just_released("call"):
				transitioned.emit(self, "OrbHugged")
	else:
		orb.menu_buttons[0].grab_focus()
		if Input.is_action_just_released("call"):
			transitioned.emit(self, "OrbOrbiting")
	
		
func exit():
	orb.menu.hide()
	print(orb.FSM.current_state)


func reveal_menu():
	orb.menu.rotation = 0
	orb.menu.show()
	orb.menu_buttons[0].grab_focus()
