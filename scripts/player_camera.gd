
extends Node3D

@export var stick_speed : float = 1.0
@export var edges_speed : float = 1.0
@export var edges_thickness : float = 1.0

var edges_boundary : Vector2 :
	get : return get_viewport().get_visible_rect().size - Vector2.ONE * edges_thickness

var mouse_position : Vector2
var stick_vector : Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var edges_vector : Vector3
	if mouse_position.x < edges_thickness :
		edges_vector.x -= 1.0
	elif mouse_position.x > edges_boundary.x :
		edges_vector.x += 1.0
	if mouse_position.y < edges_thickness :
		edges_vector.z -= 1.0
	elif mouse_position.y > edges_boundary.y :
		edges_vector.z += 1.0
	
	position += edges_vector * edges_speed * delta
	position += stick_vector * stick_speed * delta

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		mouse_position = event.position

	var input = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	stick_vector = Vector3(input.x, 0, input.y)
