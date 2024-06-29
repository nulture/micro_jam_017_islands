
extends Node3D

@export var stick_speed : float = 1.0

var stick_vector : Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += stick_vector * stick_speed * delta
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion :
		pass
		
	var input = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	stick_vector = Vector3(input.x, 0, input.y)
