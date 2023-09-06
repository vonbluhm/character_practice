extends CharacterBody2D


var max_fall_speed: float = 800.0
var grav_accel: float = 20.0
const HAND_EXTENT = 15
enum Facing {
	LEFT = -1,
	RIGHT = 1,
}
var orbiting = false
var orbiting_speed = 0.2
@onready var facing = Facing.RIGHT
@onready var hands: PathFollow2D = $Path2D/PathFollow2D
@onready var collision_shape_regular = $CollisionShape
@onready var collision_shape_expanded = $EncasedCollisionShape
@onready var orb: CharacterBody2D = get_node("../Orb")
@onready var FSM: Node = $FSM
@onready var fire_source_ring: Node2D = $FireSourceRing
@onready var jump_hold_timer: Timer = $JumpHoldTimer
var was_jump_pressed = true
var was_double_jump_pressed = true
var can_jump_after_walking_off = false


func _ready():
	add_to_group("player")
	$AnimatedSprite2D.play("default")
	hands.progress_ratio = 0.25 * (1 - facing)


func _physics_process(_delta):
	$Label.text = str(velocity) + "\n" + str(FSM.current_state.name)
	move_and_slide()
	


func set_facing():
	if Input.get_axis("move_left", "move_right") != 0:
		return sign(Input.get_axis("move_left", "move_right"))
	else:
		return facing



func apply_gravity(out: Vector2i):
	out.y = roundi(move_toward(out.y, max_fall_speed, grav_accel))
	return out.y


func is_movement_halted():
	return Input.is_action_pressed("call") or orb.FSM.current_state.name == "OrbHugged" or orb.FSM.current_state.name == "OrbInHands"


func is_on_ground():
	var out = is_on_floor() or not $CoyoteTimer.is_stopped()
	if Input.is_action_just_pressed("jump") and not out:
		out = not $CoyoteTimer.is_stopped()
		was_jump_pressed = true
		can_jump_after_walking_off = false
	elif not Input.is_action_pressed("jump") and not Input.is_action_just_released("jump"):
		coyote_time()
		out = is_on_floor() or not $CoyoteTimer.is_stopped()
	if was_jump_pressed and is_on_floor():
		was_jump_pressed = false
		was_double_jump_pressed = false
		can_jump_after_walking_off = true
	return out


func coyote_time():
	if not is_on_floor() and not was_jump_pressed and can_jump_after_walking_off:
		if $CoyoteTimer.is_stopped():
			$CoyoteTimer.start()
	elif is_on_floor():
		$CoyoteTimer.stop()
		can_jump_after_walking_off = true
