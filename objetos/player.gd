extends CharacterBody3D
class_name Player

@onready var camera: Camera3D = $camera

@export var sens_horizontal:float = 0.5
@export var sens_vertical:float = 0.5
@export var speed:float = 5.0
var pitch:float = 0.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('mouse_capture_exit'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed('mouse_capture'):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		pitch = clamp(pitch - event.relative.y * sens_vertical, -89, 89)
		camera.rotation_degrees.x = pitch


func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector('move_left', 'move_right', 'move_forward', 'move_backward')

	var forward:Vector3 = camera.global_transform.basis.z.normalized()
	var right:Vector3 = camera.global_transform.basis.x.normalized()

	var direction: Vector3 = (right * input_dir.x + forward * input_dir.y).normalized()

	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector3.ZERO, speed)

	move_and_slide()
