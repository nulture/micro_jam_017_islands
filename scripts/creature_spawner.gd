extends Node3D

@export var shape_cast : ShapeCast3D
@export var scene_pool : Array[PackedScene]
@export var spawn_rate : float = 1.0

var random = RandomNumberGenerator.new()
var counter : float

var random_creature_scene : PackedScene : 
	get : return scene_pool[random.randi_range(0, scene_pool.size() - 1)]
	
var random_water_location : Vector3 :
	get :
		var x = random.randf_range(0, Terrain.inst.terrain_bounds_size.x)
		var z = random.randf_range(0, Terrain.inst.terrain_bounds_size.y)
		var y = Terrain.inst.water_level
		
		return Vector3(x, y, z)
	
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	counter += delta
	if counter >= spawn_rate :
		for i in floor(counter / spawn_rate) :
			try_spawn()
		counter = fmod(counter, spawn_rate)

	global_position = random_water_location

func try_spawn() -> void :
	
	## The cast itself must be on land.
	if !shape_cast.is_colliding() || Terrain.inst.check_pos_overwater(shape_cast.get_collision_point(0)) :
		#print("Can't jump onto water")
		return
		
	# The center of cast must be over water.
	if !Terrain.inst.check_pos_overwater(global_position) : 
		#print("Can't spawn from land")
		return
	
	var node = random_creature_scene.instantiate()
	get_tree().root.add_child(node)
	node.spawn(global_position, shape_cast.get_collision_point(0) - global_position)
	
	print("Spawned new creature at: ", node.global_position)
