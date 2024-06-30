extends PlayerToolTerrain

const unlock_time : float = 10.0
var unlock_counter : float

func _ready() -> void:
	pass

func process_hold(delta: float) -> void:
	super.process_hold(delta)
	
	unlock_counter += delta
	if unlock_counter > unlock_time :
		PlayerCursor.inst.unlock_tool(4)
	
