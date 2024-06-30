class_name ItemsUI extends Control

@export var anim_player : AnimationPlayer

static var inst : ItemsUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inst = self
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
func set_tool(i : int) -> void :
	PlayerCursor.inst.tool_index = i
	
func play_unlock_anim(i : int) -> void :
	anim_player.play("unlock_%s" % i)
