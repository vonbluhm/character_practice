extends OrbState
class_name OrbExpanded

var offset: Vector2 = Vector2i(0, 0)


func enter():
	orb.energy_change_rate = -10
	player.collision_shape_regular.set_deferred("disabled", true)
	player.collision_shape_expanded.set_deferred("disabled", false)
	orb.global_position = player.global_position + offset
	orb.sprite.play("expanded")
	orb.reparent(player)


func exit():
	orb.sprite.play("default")
	orb.reparent(stage)
	player.collision_shape_regular.set_deferred("disabled", false)
	player.collision_shape_expanded.set_deferred("disabled", true)


func update(_delta):
	if orb.energy <= 0:
		transitioned.emit(self, "OrbComingBack")
	if Input.is_action_just_pressed("call"):
		transitioned.emit(self, "OrbComingBack")
