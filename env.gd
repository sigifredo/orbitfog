extends WorldEnvironment
class_name CustomEnvironment

@export var fog: bool = true
# @export var use_sdfgi: bool = true
# @export var sdfgi_bounces: int = 3
# @export var sdfgi_energy: float = 1.0
# @export var sdfgi_use_emission: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	environment.volumetric_fog_enabled = fog

	# if use_sdfgi:
	# 	environment.sdfgi_enabled = true
	# 	environment.sdfgi_bounces = sdfgi_bounces
	# 	environment.sdfgi_energy = sdfgi_energy
	# 	environment.sdfgi_use_emission = sdfgi_use_emission
