extends ElementState
class_name ElementFire


var drain_rate = -10
var recharge_rate = 100


func enter():
	orb.elemental_energy = 0


func _on_hurt_box_area_entered(area):
	if area.is_in_group("water_bodies"):
		transitioned.emit(self, "ElementNone")
	elif area.is_in_group("elemental_objects"):
		get_parent().element_change(area, self)
		orb.elem_energy_change_rate = recharge_rate


func _on_hurt_box_area_exited(_area):
	orb.elem_energy_change_rate = drain_rate
