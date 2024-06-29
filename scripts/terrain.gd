class_name Terrain extends MeshInstance3D

@export var known_size : float = 1.0
@export var pixels_per_unit : float = 1.0

var image : Image
var texture : ImageTexture

static var inst : Terrain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inst = self
	
	var mat = mesh.surface_get_material(0) as ShaderMaterial
	texture = mat.get_shader_parameter("height") as ImageTexture
	print(texture)
	
	var data = PackedByteArray()
	data.resize(1024 * 1024 * 12)
	image = Image.new()
	image.set_data(1024, 1024, false, Image.FORMAT_RGBF, data)
	texture.set_image(image)
	pass # Replace with function body.

func add_height(unit_position : Vector2, height : float, radius : float, falloff : float) -> void :
	#print("unit_position: ", unit_position, ", unit_radius: ", radius)
	
	unit_position -= Vector2.ONE * radius * 0.5
	radius *= pixels_per_unit
	unit_position *= pixels_per_unit
	var unit_center = unit_position
	
	var rect_position = Vector2i(unit_position)
	var rect_center = Vector2i(unit_center)
	var rect_size : int = ceil(radius * 2)
	
	#print("pixel_position: ", rect_position, ", pixel_radius: ", radius)
	
	for ix in rect_size :
		var x = rect_position.x + ix
		if x < 0 :
			continue
		elif x >= image.get_width() :
			continue
		for iy in rect_size :
			var y = rect_position.y + iy
			if y < 0 :
				continue
			elif y >= image.get_height() :
				continue
			var ipos = Vector2i(ix, iy)
			var pos = Vector2i(x, y)
			var dist = (ipos - rect_center).length()
			
			if dist > radius : continue
				
			var c = image.get_pixelv(pos)
			
			c += Color(height, height, height)
			
			image.set_pixelv(pos, c)
	
	texture.set_image(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
