extends Node3D

static var count_lights_in_world : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count_lights_in_world += 1
	if count_lights_in_world >= 3 :
		PlayerCursor.inst.unlock_tool(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
