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
@onready var hands: PathFollow2D = $Path2D/PathFollow2D
@onready var collision_shape_regular = $CollisionShape
@onready var collision_shape_expanded = $EncasedCollisionShape
@onready var orb: CharacterBody2D = get_node("../Orb")
@onready var fire_source_ring: Node2D = $FireSourceRing
@onready var fire_source: Node2D = $FireSourceRing/FireSource


func _ready():
	add_to_group("player")
	$AnimatedSprite2D.play("default")
	hands.progress_ratio = 0.25 * (1 - facing)


func _physics_process(delta):
	if not is_movement_halted():
		velocity = get_linear_velocity()
	else:
		velocity.x = 0
	facing = set_facing()
	move_and_slide()
	if orb.FSM.current_state.name.to_lower() == "orborbiting":
		hands.progress_ratio += delta * orbiting_speed
	else:
		hands.progress_ratio = 0.25 * (1 - facing)
	orient_fire_source()
	


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


func orient_fire_source():
	var input_vector = Input.get_vector("move_left", "move_right", "aim_up", "aim_down")
	var target_angle
	var angular = PI/32
	if input_vector.x == 0:
		if input_vector.y < 0:
			target_angle = -0.5 * PI
		elif input_vector.y > 0:
			target_angle = 0.5 * PI
		else:
			target_angle = acos(facing)
	elif input_vector.x != 0:
		if input_vector.y < 0:
			target_angle = (-0.5 + 0.25 * sign(input_vector.x)) * PI 
		elif input_vector.y > 0:
			target_angle = (0.5 - 0.25 * sign(input_vector.x)) * PI 
		else:
			target_angle = acos(sign(input_vector.x))
	
	if Input.is_action_just_pressed("fire"):
		fire_source_ring.rotation = target_angle
	if abs(fire_source_ring.rotation - target_angle) > 2 * PI/3:
		if abs(fire_source_ring.rotation + TAU - target_angle) > 2 * PI/3:
			if abs(fire_source_ring.rotation - TAU - target_angle) > 2 * PI/3:
				fire_source_ring.rotation = target_angle
			else:
				fire_source_ring.rotation = fire_source_ring.rotation - TAU
		else:
			fire_source_ring.rotation = fire_source_ring.rotation + TAU
	fire_source_ring.rotation = move_toward(fire_source_ring.rotation, target_angle, angular)


func is_movement_halted():
	return Input.is_action_pressed("call") or orb.FSM.current_state.name == "OrbHugged" or orb.FSM.current_state.name == "OrbRC"
