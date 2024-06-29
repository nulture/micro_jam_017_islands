extends PlayerToolHold

@export var ocean_rise_speed : float = 1.0

func process_hold(delta: float) -> void :
	World.inst.ocean_rise_node.position.y += ocean_rise_speed * delta
