class_name Creature extends Node3D

signal touch_other(other: Creature)

enum BEHAVIOR_STATE { WANDER }

@export var terrain_cast : RayCast3D

@export var wander_cast : Node3D
@export var wander_idle_timer : Timer
@export var wander_timer : Timer
@export var touch_timer : Timer
@export var birth_timer : Timer

@export_category("Physics")
@export var walk_friction : float = 5.0
@export var walk_speed : float = 1.0
@export var jump_lateral_strength : float = 1.0
@export var jump_vertical_strength : float = 1.0

@export_category("Life")
@export var species : StringName
@export var hunger_start : float = 10.0
@export var hunger_rate : float = 0.1
@export var hangry_threshold : float = 5.0

@export_category("Behavior")
@export var wander_idle_interval_min : float = 1.0
@export var wander_idle_interval_max : float = 3.0
@export var wander_length_interval_min : float = 1.0
@export var wander_length_interval_max : float = 3.0

var self_scene : PackedScene
var random = RandomNumberGenerator.new()

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity : Vector3

var hunger : float = 1.0

var is_adult = true
var is_ready = false

var _is_moving : bool = false
var is_moving : bool :
	get : return _is_moving
	set (value) :
		if _is_moving == value : return
		_is_moving = value

var is_wander_ready : bool

var is_touch_ready : bool :
	get : return is_adult && is_ready

var is_hangry : bool :
	get : return hunger < hangry_threshold
	
var wander_prospect_position : Vector3 :
	get : return wander_cast.global_position

func _ready() -> void:
	self_scene = PackedScene.new()
	self_scene.pack(self)
	
	hunger = hunger_start

func _process(delta: float) -> void:
	# Behavior
	
	# Drowning
	if is_touch_ready : 
		if terrain_cast.get_collision_point().y <= Terrain.inst.water_level :
			#print("I've drownded")
			kill()

	# Movement
	if is_moving :
		if is_touch_ready && Terrain.inst.check_is_overwater(wander_cast) :
			#print("too deep!")
			wander_stop()
		else :
			velocity -= global_basis.z * walk_speed * terrain_cast.get_collision_normal().dot(Vector3.UP)

	# Physics
	velocity.x -= velocity.x * walk_friction * delta
	velocity.z -= velocity.z * walk_friction * delta
	
	# Hunger
	hunger -= hunger_rate * delta
	if hunger < 0.0 :
		#print("I've starved")
		kill()
	
	global_position += velocity * delta

func random_with_other(other: Creature) -> bool :
	return random.randf_range(0.0, hunger + other.hunger) > hunger

func fight(other: Creature) -> void :
	#print("fight")
	if random_with_other(other) :
		hunger += other.hunger
		other.kill()
	else :
		other.hunger += hunger
		kill()
		
func mate(other: Creature) -> void :
	#print("mate")
	if random_with_other(other) :
		baby()
	else :
		other.baby()

func spawn(from: Vector3, to: Vector3) -> void :
	wander_start()
	look_at(to.normalized() * (Vector3.ONE - Vector3.UP))
	global_position = from

func kill() -> void :
	#print("kill")
	queue_free()
	
func baby() -> void :
	var node = self_scene.instantiate()
	get_tree().root.add_child(node)
	node.global_position = global_position + global_basis.x
	node.is_adult = false
	node.birth_timer.start()
	
func wander_start() -> void :
	wander_timer.wait_time = random.randf_range(wander_length_interval_min, wander_length_interval_max)
	wander_timer.start()
	global_rotation_degrees.y = randf_range(0, 360)
	is_wander_ready = false
	is_moving = true
	
func wander_stop() -> void :
	wander_idle_timer.wait_time = random.randf_range(wander_idle_interval_min, wander_idle_interval_max)
	wander_idle_timer.start()
	is_moving = false

func on_touch_area_area_entered(area: Area3D) -> void:
	var other = area.get_parent().get_parent()
	if hash(self) <= hash(other) : return
	if !other is Creature : return
	on_touch_other(other as Creature)
	
func on_touch_other(other: Creature) -> void:
	if !(is_touch_ready && other.is_touch_ready) : return
	
	touch_timer.start()
	touch_other.emit(other)
	
	if species == other.species :
		if is_hangry && other.is_hangry :
			print("We are the same species. We will kill each other for food!!")
			fight(other)
		elif is_hangry || other.is_hangry :
			print("We are the same species. One of us is hangry but we won't fight.")
			pass
		else :
			print("We are the same species. We are both sated and we will have babies.")
			mate(other)
	else :
		if is_hangry || other.is_hangry :
			print("We are different species. Let's fight!")
			fight(other)
		else :
			print("We are different species. But we're both full, so let's have babies.")
			mate(other)

func on_touch_cooldown_timeout() -> void:
	is_ready = true

func on_birth_cooldown_timeout() -> void:
	is_adult = true

func on_wander_timer_timeout() -> void:
	wander_stop()

func on_wander_idle_timer_timeout() -> void:
	wander_start()


