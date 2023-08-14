extends CharacterBody2D

var base_run_speed: int = 200
var run_accel: int = 100
var max_fall_speed: int = 800
var grav_accel: int = 200
const HAND_EXTENT = 15
enum Facing {
	LEFT = -1,
	RIGHT = 1,
}
var orbiting = false
var orbiting_speed = 0.2
@export var facing = Facing.RIGHT
@onready var hands = $Path2D/PathFollow2D
@onready var orb = get_node("../Orb")


func _ready():
	add_to_group("player")
	$AnimatedSprite2D.play("default")
	hands.progress_ratio = 0.25 * (1 - facing)


func _physics_process(delta):
	if not (Input.is_action_pressed("call") and Input.is_action_pressed("fire")):
		velocity = get_linear_velocity()
		facing = set_facing()
	else:
		velocity.x = 0
	move_and_slide()
	if orb.FSM.current_state.name.to_lower() == "orborbiting":
		hands.progress_ratio += delta * orbiting_speed
	else:
		hands.progress_ratio = 0.25 * (1 - facing)


func set_facing():
	if Input.get_axis("move_left", "move_right") != 0:
		return sign(Input.get_axis("move_left", "move_right"))
	else:
		return facing


func get_linear_velocity():
	var out: Vector2i = Vector2i.ZERO
	var x_axis: float = Input.get_axis("move_left", "move_right")
	out.x = roundi(move_toward(out.x, facing * abs(x_axis) * base_run_speed, run_accel))
	out.y = apply_gravity(out)
	return out


func apply_gravity(out: Vector2i):
	out.y = roundi(move_toward(out.y, max_fall_speed, grav_accel))
	return out.y
