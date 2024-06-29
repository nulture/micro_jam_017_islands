class_name ItemTerrainGlob extends Area3D

@export var paint_type : int = 0
@export var height : float = 1.0
@export var radius : float = 1.0
@export_range(0.0, 1.0) var hmap_falloff : float = 0.0
@export_range(0.0, 1.0) var pmap_falloff : float = 0.0

var velocity : float

func _process(delta: float) -> void:
	velocity -= PhysicsServer3D.AREA_PARAM_GRAVITY
	
	position.y += velocity * delta

func on_body_entered(body: Node) -> void:
	Terrain.inst.add_height(Vector2(global_position.x, global_position.z), paint_type, height, radius, hmap_falloff, pmap_falloff)
	queue_free()

func on_timeout() -> void:
	queue_free()
