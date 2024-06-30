class_name PlayerToolTerrain extends PlayerToolHold

@export var spawn_rate : float = 1.0

var counter : float

func _ready() -> void:
	pass

func process_hold(delta: float) -> void:
	counter += delta
	if counter >= spawn_rate :
		for i in floor(counter / spawn_rate) :
			spawn_glob()
		counter = fmod(counter, spawn_rate)
		
func tool_press() -> void :
	counter = spawn_rate
	super.tool_press()
	
func spawn_glob() -> void :
	var glob = item_prefab.instantiate()
	get_tree().root.add_child(glob)
	glob.global_position = PlayerCursor.inst.spawn_node.global_position
