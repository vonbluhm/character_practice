extends Area2D


@onready var off_screen_timer = $OffScreenTimer
@export var speed: int = 300
var direction: Vector2
var distance: float = 0.0
var time_between_bullets: float = 0.1
var energy_cost: int = 2
var tiers = 4


func _ready():
	scale = Vector2(pow(2, -tiers), pow(2, -tiers))
	direction += Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))


func _physics_process(delta):
	translate(speed * direction.normalized() * delta)
	distance += speed * delta
	var level = ceili(distance / 50)
	if level >= tiers:
		destroy()
	else:
		scale.x = pow(2, distance / 50 - tiers)
		scale.y = scale.x


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
