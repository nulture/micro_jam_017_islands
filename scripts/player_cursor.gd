class_name PlayerCursor
extends Node3D

@export var spawn_node : Node3D
@export var camera : Camera3D
@export var mouse_plane : Plane
@export var stick_speed : float = 1.0

@export var player_tools : Array[PackedScene]

static var inst : PlayerCursor

var mouse_position : Vector2
var stick_vector : Vector3
var mouse_enabled : bool

var _tool_index : int = -1
var tool_index : int = 0 :
	get : return _tool_index
	set (value) :
		if _tool_index == value || value < 0 || value >= player_tools.size()  : return
		_tool_index = value
		
		active_tool = player_tools[_tool_index].instantiate() as PlayerTool
		print("Switched to new tool '%s'" % active_tool.name)

var _active_tool : PlayerTool
var active_tool : PlayerTool :
	get : return _active_tool
	set (value) :
		if _active_tool != null :
			_active_tool.queue_free()
			
		_active_tool = value
		add_child(_active_tool)

func _ready() -> void:
	inst = self
	tool_index = 0
	pass

func _process(delta: float) -> void:
	if mouse_enabled :
		global_position = mouse_plane.intersects_ray(camera.project_ray_origin(mouse_position), camera.project_ray_normal(mouse_position))
	else :
		position += stick_vector * stick_speed * delta
	
func _input(event: InputEvent) -> void:
	
	var input = Input.get_vector("cursor_left", "cursor_right", "cursor_up", "cursor_down")
	stick_vector = Vector3(input.x, 0, input.y)
	
	if event is InputEventMouseMotion :
		mouse_enabled = true
		mouse_position = event.position
	elif input.length_squared() != 0.0 :
		mouse_enabled = false
		
	if Input.is_action_just_pressed("tool_slot_1") : 
		tool_index = 0
	if Input.is_action_just_pressed("tool_slot_2") : 
		tool_index = 1
	if Input.is_action_just_pressed("tool_slot_3") : 
		tool_index = 2
	if Input.is_action_just_pressed("tool_slot_4") : 
		tool_index = 3
	if Input.is_action_just_pressed("tool_slot_5") : 
		tool_index = 4
	if Input.is_action_just_pressed("tool_slot_6") : 
		tool_index = 5
	if Input.is_action_just_pressed("tool_slot_7") : 
		tool_index = 6
	if Input.is_action_just_pressed("tool_slot_8") : 
		tool_index = 7
	if Input.is_action_just_pressed("tool_slot_9") : 
		tool_index = 8
	if Input.is_action_just_pressed("tool_slot_left") : 
		tool_index -= 1
	if Input.is_action_just_pressed("tool_slot_right") : 
		tool_index += 1
