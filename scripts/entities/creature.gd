class_name Creature extends CharacterBody3D

signal touch_other(other: Creature)

@export var touch_timer : Timer
@export var birth_timer : Timer

@export_category("Physics")
@export var friction : float = 5.0
@export var jump_lateral_strength : float = 1.0
@export var jump_vertical_strength : float = 1.0

@export_category("Life")
@export var species : StringName
@export var hunger_max : float = 10.0
@export var hunger_rate : float = 0.1
@export var hangry_threshold : float = 5.0

var self_scene : PackedScene
var random = RandomNumberGenerator.new()

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

var hunger : float = 1.0

var is_adult = true
var is_ready = false

var is_touch_ready : bool :
	#get : return touch_timer.is_stopped() && birth_timer.is_stopped()
	get : return is_adult && is_ready

var is_hangry : bool :
	get : return hunger < hangry_threshold

func _ready() -> void:
	self_scene = PackedScene.new()
	self_scene.pack(self)
	
	hunger = hunger_max
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") :
		print("spawn")
		spawn(global_position, global_basis.x)

func _physics_process(delta: float) -> void:
	if is_on_floor() :
		velocity.x -= velocity.x * friction * delta
		velocity.z -= velocity.z * friction * delta
	else :
		velocity.y -= gravity * delta

	move_and_slide()
	
	
	# Hunger
	hunger -= hunger_rate * delta
	if hunger < 0.0 :
		print("I've starved")
		kill()

	# Prevent death on spawn or if not ready to touch
	if !is_touch_ready : return
	
	# Drowning
	if Terrain.inst.check_is_underwater(self) :
		print("I've drownded")
		kill()

func random_with_other(other: Creature) -> bool :
	return random.randf_range(0.0, hunger + other.hunger) > hunger

func fight(other: Creature) -> void :
	print("fight")
	if random_with_other(other) :
		other.kill()
	else :
		kill()
		
func mate(other: Creature) -> void :
	print("mate")
	if random_with_other(other) :
		baby()
	else :
		other.baby()

func spawn(from: Vector3, to: Vector3) -> void :
	global_position = from
	velocity = to * jump_lateral_strength + Vector3.UP * jump_vertical_strength

func kill() -> void :
	queue_free()
	
func baby() -> void :
	var node = self_scene.instantiate()
	get_tree().root.add_child(node)
	node.global_position = global_position + global_basis.x
	node.is_adult = false
	node.birth_timer.start()

#
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
#
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()

func on_touch_area_body_entered(body: Node3D) -> void:
	if hash(self) <= hash(body) : return
	if !body is Creature : return
	on_touch_other(body as Creature)
	
func on_touch_other(other: Creature) -> void:
	if !(is_touch_ready && other.is_touch_ready) : return
	
	touch_timer.start()
	touch_other.emit(other)
	
	if species == other.species :
		if is_hangry && other.is_hangry :
			#print("We are the same species. We will kill each other for food!!")
			fight(other)
		elif is_hangry || other.is_hangry :
			#print("We are the same species. One of us is hangry but we won't fight.")
			pass
		else :
			#print("We are the same species. We are both sated and we will have babies.")
			mate(other)
	else :
		if is_hangry || other.is_hangry :
			#print("We are different species. Let's fight!")
			fight(other)
		else :
			#print("We are different species. But we're both full, so let's have babies.")
			mate(other)

func on_touch_cooldown_timeout() -> void:
	is_ready = true

func on_birth_cooldown_timeout() -> void:
	is_adult = true
