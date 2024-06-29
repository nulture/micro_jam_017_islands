class_name PlayerToolHold extends PlayerTool

var is_active : bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active :
		process_hold(delta)

func process_hold(delta: float) -> void :
	pass

func tool_press() -> void :
	is_active = true
	
func tool_release() -> void :
	is_active = false
