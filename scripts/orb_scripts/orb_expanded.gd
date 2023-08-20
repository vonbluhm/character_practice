extends OrbState
class_name OrbExpanded

var offset: Vector2 = Vector2i(0, 0)
var firing_timer: Timer
var bullet_scene: PackedScene
var picked_bullet: Area2D


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
	if Input.is_action_just_pressed("call"):
		transitioned.emit(self, "OrbComingBack")


func physics_update(_delta):
	if Input.is_action_just_pressed("fire"):
		start_firing()
	if Input.is_action_just_released("fire"):
		if firing_timer:
			firing_timer.stop()
	if Input.is_action_just_pressed("secondary"):
		pass


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
		bullet.global_position = orb.firing_ring.source.global_position
		bullet.direction = (orb.firing_ring.source.global_position - orb.global_position).normalized()
		get_tree().get_root().add_child(bullet)
		orb.energy -= bullet.energy_cost


func _on_timeout():
	start_firing()
