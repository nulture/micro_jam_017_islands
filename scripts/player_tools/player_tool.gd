class_name PlayerTool 
extends Node3D

@export var item_prefab : PackedScene

func _input(event: InputEvent) -> void:
	if PlayerCursor.is_mouse_cursor_in_world :
		if Input.is_action_just_pressed("use_tool") :
			tool_press()
		elif Input.is_action_just_released("use_tool") :
			tool_release()
	else :
		tool_release()
		
func tool_press() -> void :
	pass
	
func tool_release() -> void :
	pass
