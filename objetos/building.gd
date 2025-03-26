extends StaticBody3D
class_name Building


@export_range(0.0, 10.0, 0.1)
var color_change_speed: float = 0.05


var shared_material: StandardMaterial3D = null
var time:float = 0.0


func _create_material() -> StandardMaterial3D:
	var material = StandardMaterial3D.new()

	material.emission_enabled = true
	material.emission_energy_multiplier = 10
	material.emission = Color(0.65, 0.33, 1.0)

	return material


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var neon_parent:Node3D = get_node('neon')

	if neon_parent:
		shared_material = _create_material()

		for neon in neon_parent.get_children():
			neon.material_override = shared_material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta

	if shared_material:
		var cc:Color = shared_material.emission

		shared_material.emission = Color.from_hsv(
			fmod(time * color_change_speed + position.x + position.y + position.x, 1.0),
			cc.s,
			cc.v
		)
