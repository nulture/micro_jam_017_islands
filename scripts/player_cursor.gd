extends Node3D

@export var camera : Camera3D
@export var mouse_plane : Plane
@export var stick_speed : float = 1.0

var mouse_position : Vector2
var stick_vector : Vector3
var mouse_enabled : bool

func _ready() -> void:
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
