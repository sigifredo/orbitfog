extends StaticBody3D
class_name Building

@export_range(0.0, 10.0, 0.1)
var color_change_speed: float = 0.05


var shared_material: StandardMaterial3D
var time:float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = position.x + position.y + position.z
	var mesh:MeshInstance3D = get_node("neon01")

	if mesh:
		var material = mesh.get_active_material(0)

		if material is StandardMaterial3D:
			shared_material = material
			shared_material.emission_enabled = true
	else:
		print("Material no encontrado")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shared_material:
		var cc:Color = shared_material.emission

		time += delta
		shared_material.emission = Color.from_hsv(fmod(time * color_change_speed, 1.0), cc.s, cc.v)
