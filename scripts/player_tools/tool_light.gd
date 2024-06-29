extends PlayerTool

func tool_press() -> void :
	var item = item_prefab.instantiate()
	get_tree().root.add_child(item)
	item.global_position = global_position
	
func tool_release() -> void :
	pass
