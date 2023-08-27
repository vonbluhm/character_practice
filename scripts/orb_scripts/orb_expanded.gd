extends OrbState
class_name OrbExpanded

var offset: Vector2 = Vector2i(0, 0)
var firing_timer: Timer
var bullet_scene: PackedScene
var picked_bullet: Area2D
var beam_node

func enter():
	orb.energy_change_rate = -10
	orb.regular_hurtbox_shape.set_deferred("disabled", true)
	orb.expanded_hurtbox_shape.set_deferred("disabled", false)
	player.collision_shape_regular.set_deferred("disabled", true)
	player.collision_shape_expanded.set_deferred("disabled", false)
	orb.global_position = player.global_position + offset
	orb.firing_ring.radius = 30
	orb.reparent(player)
	


func exit():
	orb.reparent(stage)
	orb.regular_hurtbox_shape.set_deferred("disabled", false)
	orb.expanded_hurtbox_shape.set_deferred("disabled", true)
	player.collision_shape_regular.set_deferred("disabled", false)
	player.collision_shape_expanded.set_deferred("disabled", true)
	orb.firing_ring.radius = 10
	if firing_timer:
		firing_timer.stop()


func update(_delta):
	if orb.energy <= 0:
		transitioned.emit(self, "OrbComingBack")
	if Input.is_action_just_pressed("call") and not Input.is_action_pressed("fire"):
		transitioned.emit(self, "OrbComingBack")
	if Input.is_action_just_released("fire"):
		orb.energy_change_rate = -10
	if orb.elem_FSM.current_state.name != "ElementCrystal" and beam_node != null:
		beam_node.queue_free()


func physics_update(_delta):
	if Input.is_action_just_pressed("fire"):
		if orb.elem_FSM.current_state.name != "ElementCrystal":
			start_firing()
		else:
			start_beam()
	if Input.is_action_pressed("fire") and orb.elem_FSM.current_state.name != "ElementCrystal":
		if beam_node != null:
			start_beam()
		else:
			orient_beam()
	if Input.is_action_just_released("fire"):
		if firing_timer:
			firing_timer.stop()
	


func start_firing():
	bullet_scene = pick_bullet()
	if bullet_scene != null:
		picked_bullet = bullet_scene.instantiate()
		fire_bullet(picked_bullet)
	
	

func pick_bullet():
	match orb.elemental_power.name:
		"ElementNone":
			return orb.nonelem_bullet_scene
		"ElementWater":
			return orb.water_bullet_scene
		"ElementAir":
			return orb.air_bullet_scene
		"ElementFire":
			return orb.fire_bullet_scene


func set_timer(bullet: Area2D):
	if orb.elem_FSM.current_state.name != "ElementCrystal":
		if !firing_timer:
			firing_timer = Timer.new()
			firing_timer.wait_time = bullet.time_between_bullets
			firing_timer.autostart = true
			firing_timer.timeout.connect(_on_timeout)
			add_child(firing_timer)
		else:
			firing_timer.wait_time = bullet.time_between_bullets
			firing_timer.start()
	else:
		pass
		#


func fire_bullet(bullet):
	if orb.elem_FSM.current_state.name != "ElementCrystal":
		set_timer(bullet)
		if orb.energy >= bullet.energy_cost:
			bullet.global_position = orb.firing_ring.source.global_position
			bullet.direction = (orb.firing_ring.source.global_position - orb.global_position).normalized()
			bullet.rotation = orb.firing_ring.rotation
			get_tree().get_root().add_child(bullet)
			orb.energy -= bullet.energy_cost


func is_a_beam(node):
	return node.is_in_group("beams")


func start_beam():
	var beam = orb.beam_scene.instantiate()
	beam.global_position = orb.firing_ring.source.position * 2
	beam.direction = Vector2.from_angle(orb.firing_ring.rotation)
	if orb.energy >= beam.consumption_rate and not orb.get_children().any(is_a_beam):
		beam.add_to_group("beams")
		beam.source = orb.firing_ring
		orb.add_child(beam)
		orb.energy_change_rate += beam.consumption_rate


func orient_beam():
	var beam = beam_node
	if beam != null:
		beam.global_position = orb.firing_ring.source.position
		beam.direction = Vector2.from_angle(orb.firing_ring.rotation)


func _on_timeout():
	start_firing()

