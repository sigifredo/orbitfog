extends CharacterBody3D
class_name Player

@onready var camera_mount: Node3D = $camera_mount
@onready var camera: Camera3D = $camera_mount/camera

@export var speed:float = 5.0
@export var orbit:bool = true
@export var sens_horizontal:float = 0.5
@export var sens_vertical:float = 0.5
@export var walk_fov:float = 75.0
@export var run_fov:float = 95.0

const JUMP_VELOCITY: float = 4.5

var running:bool = false
var run_tween:Tween = null


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('mouse_capture_exit'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed('mouse_capture'):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event.is_action_pressed('run'):
		running = true
		_run_tween_animation(run_fov)
	elif event.is_action_released('run'):
		running = false
		_run_tween_animation(walk_fov)

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		var new_pitch:float = camera_mount.rotation.x + deg_to_rad(-event.relative.y * sens_vertical)
		camera_mount.rotation.x = clamp(new_pitch, -PI / 2.0, PI / 2.0)


func _physics_process(delta: float) -> void:

	if not orbit:
		if is_on_floor():
			if Input.is_action_just_pressed('jump'):
				velocity.y = JUMP_VELOCITY
		else:
			# Add the gravity.
			velocity += get_gravity() * delta

	var real_speed:float = speed * 2.0 if running else speed
	var input_dir: Vector2 = Input.get_vector('move_left', 'move_right', 'move_forward', 'move_backward')
	var forward:Vector3 = camera_mount.global_transform.basis.z.normalized()
	var right:Vector3 = camera_mount.global_transform.basis.x.normalized()

	if orbit:
		var direction:Vector3 = (right * input_dir.x + forward * input_dir.y).normalized()

		if direction:
			velocity = direction * real_speed
		else:
			velocity = velocity.move_toward(Vector3.ZERO, real_speed)
	else:
		var direction:Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if direction:
			velocity.x = direction.x * real_speed
			velocity.z = direction.z * real_speed
		else:
			velocity.x = move_toward(velocity.x, 0, real_speed)
			velocity.z = move_toward(velocity.z, 0, real_speed)

	move_and_slide()


func _run_tween_animation(new_fov:float) -> void:
	if run_tween and run_tween.is_running():
		run_tween.kill()

	run_tween = create_tween()
	run_tween.tween_property(camera, 'fov', new_fov, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func get_look_direction() -> Vector3:
	return -camera.global_transform.basis.z.normalized()
