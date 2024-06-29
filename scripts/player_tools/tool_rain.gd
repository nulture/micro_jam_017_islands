extends PlayerTool

@export var ocean_rise_speed : float = 1.0

var is_raining : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_raining :
		World.inst.ocean_rise_node.position.y += ocean_rise_speed * delta
	
func tool_press() -> void :
	is_raining = true
	
func tool_release() -> void :
	is_raining = false
