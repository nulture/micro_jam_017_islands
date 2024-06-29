class_name World
extends Node3D

@export var ocean_rise_node : Node3D

static var inst : World

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inst = self
