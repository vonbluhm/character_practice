extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

signal element_changed

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.update(delta)


func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)


func _on_child_transition(state, new_state_name):
	if state != current_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		element_changed.emit()
		current_state.exit()
	new_state.enter()
	current_state = new_state


func element_change(area: Area2D, state: State):
	if area.is_in_group("water_sources") and state.name != "ElementWater":
		state.transitioned.emit(state, "ElementWater")
	elif area.is_in_group("air_sources") and state.name != "ElementAir":
		state.transitioned.emit(state, "ElementAir")
	elif area.is_in_group("crystal_sources") and state.name != "ElementCrystal":
		state.transitioned.emit(state, "ElementCrystal")
	elif area.is_in_group("fire_sources") and state.name != "ElementFire":
		state.transitioned.emit(state, "ElementFire")
	
	
