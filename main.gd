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


var building_scene: PackedScene = preload('res://objetos/building.tscn')
var spawned_elements:Dictionary = {}
var time_accumulator:float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred('_update_elements', 0.1, 1.0, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_accumulator += delta

	if time_accumulator >= update_interval:
		time_accumulator = 0.0
		_update_elements(0.5, 1.0)

func _update_elements(distance_start:float, distance_end:float, start:bool = false):
	for instance in spawned_elements.keys():
		if instance.position.distance_to(player.position) > spawn_radius:
			instance.queue_free()
			spawned_elements.erase(instance)

	while spawned_elements.size() < density:
		var building = building_scene.instantiate()

		if start:
			var dir:Vector3 = Vector3(
				randf_range(-1.0, 1.0),
				randf_range(-1.0, 1.0),
				randf_range(-1.0, 1.0)
			).normalized()

			building.position = player.position + dir * randf_range(distance_start, distance_end) * spawn_radius
		else:
			var dir:Vector3 = player.get_look_direction()
			var lateral_offset = player.global_transform.basis.x.normalized() * randf_range(-100.0, 100.0)
			var vertical_offset = player.global_transform.basis.y.normalized() * randf_range(-100.0, 100.0)

			building.position = player.position + dir * randf_range(distance_start, distance_end) * spawn_radius + lateral_offset + vertical_offset

		building.rotate_x(randf_range(0, TAU))
		building.rotate_y(randf_range(0, TAU))
		building.rotate_z(randf_range(0, TAU))

		add_child(building)
		spawned_elements[building] = true
