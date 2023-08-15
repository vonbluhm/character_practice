extends Area2D


@export var speed: int = 300
var direction: Vector2
var distance: float = 0.0
var threshold: int = 200


func _physics_process(delta):
	translate(speed * direction * delta)
	distance += speed * delta
	if distance >= threshold:
		queue_free() 


func destroy():
	queue_free()


func _on_area_entered(_area):
	destroy()


func _on_body_entered(_body):
	destroy()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
