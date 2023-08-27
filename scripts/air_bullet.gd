extends Area2D


@onready var off_screen_timer = $OffScreenTimer
@export var speed: int = 300
var direction: Vector2
var time_between_bullets: float = 0.1
var energy_cost: float = 0.5


func _physics_process(delta):
	translate(speed * direction * delta)


func destroy():
	queue_free()


func _on_area_entered(_area):
	destroy()


func _on_body_entered(_body):
	destroy()


func _on_visible_on_screen_notifier_2d_screen_exited():
	off_screen_timer.start()


func _on_off_screen_timer_timeout():
	queue_free()
