extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_mouse_entered() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func on_mouse_exited() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
