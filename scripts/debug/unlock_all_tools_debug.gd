extends Node3D

func _ready() -> void:
	if !visible : return
	PlayerCursor.inst.unlock_tool(0)
	PlayerCursor.inst.unlock_tool(1)
	PlayerCursor.inst.unlock_tool(2)
	PlayerCursor.inst.unlock_tool(3)
	PlayerCursor.inst.unlock_tool(4)
