extends Area2D


@onready var off_screen_timer = $OffScreenTimer
@export var speed: int = 300
var direction: Vector2
var distance: float = 0.0
var time_between_bullets: float = 0.1
var energy_cost: int = 1
var is_in_water: bool = false


func _physics_process(delta):
	if not is_in_water:
		direction.y = move_toward(direction.y, 200, 2 * delta)
	translate(speed * direction * delta)
	distance += speed * delta 


func destroy():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("water_bodies"):
		is_in_water = true
	else:
		destroy()


func _on_area_exited(area):
	if area.is_in_group("water_bodies"):
		is_in_water = false


func _on_body_entered(_body):
	destroy()


func _on_visible_on_screen_notifier_2d_screen_exited():
	off_screen_timer.start()


func _on_off_screen_timer_timeout():
	queue_free()

