extends PlayerToolHold

@export var ocean_rise_speed : float = 1.0

func process_hold(delta: float) -> void :
	Terrain.inst.water_level += ocean_rise_speed * delta
