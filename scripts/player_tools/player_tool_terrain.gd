class_name PlayerToolTerrain extends PlayerToolHold

@export var paint_type : int = 0
@export var height : float = 1.0
@export var radius : float = 1.0
@export var falloff : float = 0.0

func _ready() -> void:
	pass

func process_hold(delta: float) -> void:
	Terrain.inst.add_height(Vector2(global_position.x, global_position.z), height, radius, falloff)
	pass
