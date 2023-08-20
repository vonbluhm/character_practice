extends OrbState
class_name OrbHeld

var firing_timer: Timer
var bullet_scene: PackedScene
var picked_bullet: Area2D


func enter():
	orb.energy_change_rate = 5
	orb.collision_mask -= 1
	orb.reparent(player.fire_source_ring.source)
	if Input.is_action_pressed("fire"):
		start_firing()


func update(_delta):
	if Input.is_action_pressed("call") and not Input.is_action_pressed("fire"):
		transitioned.emit(self, "OrbInHands")


func physics_update(_delta):
	if Input.is_action_just_pressed("fire"):
		start_firing()
	if Input.is_action_just_released("fire"):
		if firing_timer:
			firing_timer.stop()


func exit():
	orb.collision_mask += 1
	orb.reparent(get_tree().get_first_node_in_group("stage"))


func start_firing():
	bullet_scene = pick_bullet()
	picked_bullet = bullet_scene.instantiate()
	fire_bullet(picked_bullet)
	

func pick_bullet():
	match orb.elemental_power.name:
		"ElementNone":
			return orb.nonelem_bullet_scene
		"ElementWater":
			return orb.water_bullet_scene
		"ElementAir":
			pass
		"ElementCrystal":
			pass
		"ElementFire":
			pass


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


func fire_bullet(bullet: Area2D):
	set_timer(bullet)
	if orb.energy >= bullet.energy_cost:
		bullet.global_position = orb.global_position + Vector2(10.0, 0.0).rotated(player.fire_source_ring.rotation)
		bullet.direction = (orb.global_position - player.global_position).normalized()
		get_tree().get_root().add_child(bullet)
		orb.energy -= bullet.energy_cost


func _on_timeout():
	start_firing()

