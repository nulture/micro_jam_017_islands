
extends Node3D

@export var sprint_multiplier : float = 2.0
@export var stick_speed : float = 1.0
@export var edges_speed : float = 1.0
@export var edges_thickness : float = 1.0

var _sprint_multiplier : float = 1.0
var _is_sprinting : bool
var is_sprinting : bool :
	get : return _is_sprinting
	set (value) :
		if _is_sprinting == value : return
		_is_sprinting = value
		
		if _is_sprinting : _sprint_multiplier = sprint_multiplier
		else : _sprint_multiplier = 1.0

var edges_boundary : Vector2 :
	get : return get_viewport().get_visible_rect().size - Vector2.ONE * edges_thickness


var mouse_position : Vector2
var stick_vector : Vector3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var edges_vector = Vector3.ZERO
	if mouse_position.x < edges_thickness :
		edges_vector.x -= 1.0
	elif mouse_position.x > edges_boundary.x :
		edges_vector.x += 1.0
	if mouse_position.y < edges_thickness :
		edges_vector.z -= 1.0
	elif mouse_position.y > edges_boundary.y :
		edges_vector.z += 1.0
	
	position += edges_vector * edges_speed * _sprint_multiplier * delta
	position += stick_vector * stick_speed * _sprint_multiplier * delta

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		mouse_position = event.position

	var input = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	stick_vector = Vector3(input.x, 0, input.y)
	
	if Input.is_action_just_pressed("camera_sprint") : is_sprinting = true
	elif Input.is_action_just_released("camera_sprint") : is_sprinting = false
