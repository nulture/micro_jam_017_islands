class_name PlayerToolTerrain extends PlayerToolHold

func _ready() -> void:
	pass

func process_hold(delta: float) -> void:
	var glob = item_prefab.instantiate()
	get_tree().root.add_child(glob)
	glob.global_position = PlayerCursor.inst.spawn_node.global_position
