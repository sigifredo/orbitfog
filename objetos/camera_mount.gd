extends Node3D
class_name CameraMount

@export
var size: float = 253.0
@export
var speed: float = 10

# Variables
var time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta * speed
	position.z = size * sin(time * 0.0005)
	rotate_x(-delta * 0.1)
	rotate_y(delta * 0.05)
