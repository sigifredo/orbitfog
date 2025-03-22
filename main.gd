extends Node3D
class_name Main

# @onready var camera_mount: CameraMount = $camera_mount
@onready var player: Player = $player


# Número máximo de instancias activas generadas alrededor de la cámara.
@export var density:int = 30
# Radio en metros alrededor de la cámara donde se generan instancias.
@export var spawn_radius: float = 50.0
# Tiempo (en segundos) entre actualizaciones del sistema de instancias.
@export var update_interval: float = 1.0


var building_scene: PackedScene = preload("res://objetos/building.tscn")
var spawned_elements:Dictionary = {}
var time_accumulator:float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_update_elements", 0.1, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_accumulator += delta

	if time_accumulator >= update_interval:
		time_accumulator = 0.0
		_update_elements(0.7, 1.0)

func _update_elements(distance_start:float, distance_end:float):
	for instance in spawned_elements.keys():
		if instance.position.distance_to(player.position) > spawn_radius:
			instance.queue_free()
			spawned_elements.erase(instance)

	while spawned_elements.size() < density:
		var building = building_scene.instantiate()
		# building.global_transform.origin = _get_random_position(camera_mount.position, distance_start, distance_end)
		building.position = _get_random_position(player.position, distance_start, distance_end)
		building.rotate_x(randf_range(0, TAU))
		building.rotate_y(randf_range(0, TAU))
		building.rotate_z(randf_range(0, TAU))

		add_child(building)
		spawned_elements[building] = true

func _get_random_position(center:Vector3, distance_start:float, distance_end:float) -> Vector3:
	# Generar una dirección aleatoria en 3D (vector normalizado)
	var dir:Vector3 = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	# Elegir una distancia aleatoria entre el mínimo y máximo
	var distance = randf_range(distance_start, distance_end) * spawn_radius

	# Multiplicar la dirección por la distancia y sumar al centro
	return center + dir * distance
