extends PlayerToolHold

@export var ocean_rise_speed : float = 1.0

func process_hold(delta: float) -> void :
	Terrain.inst.water_level += ocean_rise_speed * delta

func tool_release() :
	super.tool_release()
	PlayerCursor.inst.unlock_tool(2)
	PlayerCursor.inst.unlock_tool(3)
