extends OrbState
class_name OrbInHands


func enter():
	player = get_tree().get_first_node_in_group("player")
	orb.global_position = player.fire_source.global_position
	orb.velocity = Vector2.ZERO
	if Input.is_action_pressed("call"):
		reveal_menu()


func update(_delta):
	if Input.is_action_just_pressed("call"):
		reveal_menu()
	if Input.is_action_just_released("call"):
		transitioned.emit(self, "OrbOrbiting")
	if Input.is_action_pressed("fire"):
		transitioned.emit(self, "OrbHeld")
	
	var input_vector = Input.get_vector("move_left", "move_right", "aim_up", "aim_down")
	if input_vector == Vector2.ZERO:
		orb.menu_buttons[0].grab_focus()
		

func exit():
	orb.menu.hide()


func reveal_menu():
	orb.menu.rotation = 0
	orb.menu.show()
	orb.menu_buttons[0].grab_focus()


func _on_texture_button_pressed():
	pass # Replace with function body.


func _on_texture_button_2_pressed():
	pass # Replace with function body.


func _on_texture_button_3_pressed():
	pass # Replace with function body.


func _on_texture_button_4_pressed():
	transitioned.emit(self, "OrbHugged")
