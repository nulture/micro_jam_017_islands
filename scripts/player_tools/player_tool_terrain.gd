class_name PlayerToolTerrain extends PlayerToolHold

@export var paint_type : int = 0
@export var height : float = 1.0
@export var radius : float = 1.0
@export_range(0.0, 1.0) var falloff : float = 0.0

func _ready() -> void:
	pass

func process_hold(delta: float) -> void:
	var glob = item_prefab.instantiate()
	get_tree().root.add_child(glob)
	glob.global_position = PlayerCursor.inst.spawn_node.global_position
	#Terrain.inst.add_height(Vector2(global_position.x, global_position.z), height, radius, falloff)
	pass
