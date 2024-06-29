class_name Terrain extends Node3D

@export var shape : CollisionShape3D
@export var mesh : MeshInstance3D

@export var pixels : int = 256
@export var known_size : float = 1.0
@export var pixels_per_unit : float = 1.0

var hmap_shape : HeightMapShape3D
var hmap_image : Image
var hmap_texture : ImageTexture

static var inst : Terrain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inst = self
	
	var mat = mesh.mesh.surface_get_material(0) as ShaderMaterial
	hmap_texture = mat.get_shader_parameter("height") as ImageTexture
	
	var data = PackedByteArray()
	data.resize(pixels * pixels * 4)
	hmap_image = Image.new()
	hmap_image.set_data(pixels, pixels, false, Image.FORMAT_RF, data)
	hmap_texture.set_image(hmap_image)
	
	hmap_shape = shape.shape
	hmap_shape.map_width = pixels
	hmap_shape.map_depth = pixels
	hmap_shape.map_data = hmap_image.get_data().to_float32_array()

func add_height(unit_position : Vector2, height : float, radius : float, falloff : float) -> void :	
	unit_position -= Vector2.ONE * radius
	radius *= pixels_per_unit
	unit_position *= pixels_per_unit
	
	var rect_position = Vector2i(unit_position)
	var rect_size = Vector2i(ceil(radius), ceil(radius)) * 2 
	
	for ix in rect_size.x :
		var x = rect_position.x + ix
		if x < 0 :
			continue
		elif x >= hmap_image.get_width() :
			continue
		for iy in rect_size.y :
			var y = rect_position.y + iy
			if y < 0 :
				continue
			elif y >= hmap_image.get_height() :
				continue
			var ipos = Vector2i(ix, iy)
			var pos = Vector2i(x, y)
			var dist = (ipos - rect_size / 2).length()
			
			if dist > radius : continue

			var alpha = remap(dist / radius, falloff, 1.0, 1.0, 0.0)
			# Do powers and such here
			var ih = height * clamp(alpha, 0.0, 1.0)
			
			var c = hmap_image.get_pixelv(pos)
			c += Color(ih, ih, ih)
			hmap_image.set_pixelv(pos, c)

	hmap_texture.set_image(hmap_image)

func _physics_process(delta: float) -> void:
	hmap_shape.map_data = hmap_image.get_data().to_float32_array()

func _process(delta: float) -> void:
	pass
