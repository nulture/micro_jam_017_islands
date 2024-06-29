class_name Terrain extends Node3D

@export var shape : CollisionShape3D
@export var mesh : MeshInstance3D

@export var hmap_size : int = 256
@export var pmap_size : int = 256
@export var known_size : float = 1.0
@export var pixels_per_unit : float = 1.0

var hmap_shape : HeightMapShape3D
var hmap_image : Image
var hmap_texture : ImageTexture
var hmap_min_height : float

var pmap_image : Image
var pmap_texture : ImageTexture

static var inst : Terrain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inst = self
	
	var mat = mesh.mesh.surface_get_material(0) as ShaderMaterial
	hmap_texture = mat.get_shader_parameter("height") as ImageTexture
	pmap_texture = mat.get_shader_parameter("paint") as ImageTexture
	
	var hmap_data = PackedByteArray()
	hmap_data.resize(hmap_size * hmap_size * 4)
	hmap_image = Image.new()
	hmap_image.set_data(hmap_size, hmap_size, false, Image.FORMAT_RF, hmap_data)
	hmap_texture.set_image(hmap_image)
	
	var pmap_data = PackedByteArray()
	pmap_data.resize(pmap_size * pmap_size * 3)
	pmap_image = Image.new()
	pmap_image.set_data(pmap_size, pmap_size, false, Image.FORMAT_RGB8, pmap_data)
	pmap_texture.set_image(pmap_image)
	
	hmap_shape = shape.shape
	hmap_shape.map_width = hmap_size
	hmap_shape.map_depth = hmap_size
	hmap_shape.map_data = hmap_image.get_data().to_float32_array()

func add_height(unit_position : Vector2, paint : int, height : float, radius : float, hmap_falloff : float, pmap_falloff : float) -> void :
	var paint_color : Color
	match paint :
		0 : paint_color = Color.BLACK
		1 : paint_color = Color.RED
		2 : paint_color = Color.GREEN
		3 : paint_color = Color.BLUE
		_ : push_error("Only 4 terrain paints are supported.")
	
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

			var percent = dist / radius
			var hmap_alpha = remap(percent, hmap_falloff, 1.0, 1.0, 0.0)
			# Do powers and such here
			hmap_alpha = height * clamp(hmap_alpha, 0.0, 1.0)
			var hmap_color = hmap_image.get_pixelv(pos)
			var r = hmap_color.r + hmap_alpha
			hmap_color = Color(max(r, hmap_min_height), 0, 0)
			hmap_image.set_pixelv(pos, hmap_color)
			
			var pmap_alpha = remap(percent, pmap_falloff, 1.0, 1.0, 0.0)
			pmap_alpha = paint * clamp(pmap_alpha, 0.0, 1.0)
			var pmap_color = pmap_image.get_pixelv(pos)
			pmap_color = lerp(pmap_color, paint_color, pmap_alpha)
			pmap_image.set_pixelv(pos, pmap_color)

	hmap_texture.set_image(hmap_image)
	pmap_texture.set_image(pmap_image)

func _physics_process(delta: float) -> void:
	hmap_shape.map_data = hmap_image.get_data().to_float32_array()
	
func get_height_at(coord : Vector2i) -> float : 
	return 0.0

func get_paint_at(coord : Vector2i) -> int :
	return 0
