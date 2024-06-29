class_name PlayerTool 
extends Node3D

@export var item_prefab : PackedScene

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_tool") :
		tool_press()
	elif Input.is_action_just_released("use_tool") :
		tool_release()
		
func tool_press() -> void :
	pass
	
func tool_release() -> void :
	pass
