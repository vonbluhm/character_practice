extends Node2D


@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var source = $FireSource
@export var radius: float = 0

func _ready():
	source.position = Vector2(radius, 0.0)

func _process(_delta):
	source.position = Vector2(radius, 0.0)
	
	
func _physics_process(_delta):
	var input_vector = Input.get_vector("move_left", "move_right", "aim_up", "aim_down")
	var target_angle
	var angular = PI/32
	if input_vector.x == 0:
		if input_vector.y < 0:
			target_angle = -0.5 * PI
		elif input_vector.y > 0:
			target_angle = 0.5 * PI
		else:
			target_angle = acos(player.facing)
	elif input_vector.x != 0:
		if input_vector.y < 0:
			target_angle = (-0.5 + 0.25 * sign(input_vector.x)) * PI 
		elif input_vector.y > 0:
			target_angle = (0.5 - 0.25 * sign(input_vector.x)) * PI 
		else:
			target_angle = acos(sign(input_vector.x))
	
	if Input.is_action_just_pressed("fire"):
		rotation = target_angle
	if abs(rotation - target_angle) > 2 * PI/3:
		if abs(rotation + TAU - target_angle) > 2 * PI/3:
			if abs(rotation - TAU - target_angle) > 2 * PI/3:
				rotation = target_angle
			else:
				rotation = rotation - TAU
		else:
			rotation = rotation + TAU
	rotation = move_toward(rotation, target_angle, angular)
