extends OrbState
class_name OrbHeld

var firing_timer: Timer
var bullet_scene: PackedScene


func enter():
	orb.collision_mask -= 1
	orb.reparent(player.hands)
	match orb.elemental_power:
		0:
			bullet_scene = preload("res://scenes/non_elem_bullet.tscn")
	if Input.is_action_pressed("fire"):
		start_firing()


func update(_delta):
	if Input.is_action_just_pressed("call"):
		transitioned.emit(self, "OrbInHands")


func physics_update(_delta):
	if Input.is_action_just_pressed("fire"):
		start_firing()
	if Input.is_action_just_released("fire"):
		if firing_timer:
			firing_timer.stop()


func exit():
	orb.collision_mask += 1


func start_firing():
	if !firing_timer:
		firing_timer = Timer.new()
		firing_timer.wait_time = 0.2
		firing_timer.autostart = true
		firing_timer.timeout.connect(_on_timeout)
		add_child(firing_timer)
	else:
		firing_timer.start()
	var bullet = bullet_scene.instantiate()
	bullet.global_position = orb.global_position
	bullet.direction.x = player.facing
	get_tree().get_root().add_child(bullet)


func _on_timeout():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = orb.global_position
	bullet.direction.x = player.facing
	get_tree().get_root().add_child(bullet)
