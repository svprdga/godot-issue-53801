extends BaseCreature

class_name PlayerController

# Export vars

export var jump_force: float = 200
export var max_jump_force: float = 2000.0
export var after_hit_enemy_jump_force: float = 1250

# Private vars

var _should_apply_jump_force: bool = false
var _current_max_jump_force: float = 0.0
var _last_is_on_floor: bool = false
var _enable_double_jump: bool = true
var _is_double_jump: bool = false

# Lifecycle


func _physics_process(_delta: float) -> void:
	_horizontal_movement()
	_jump_action()
	_vertical_movement()

	# Apply movement
	movement_vector = move_and_slide_with_snap(movement_vector, Vector2.DOWN, Vector2.UP)


# Override methods


func after_receive_damage():
	pass


# Private functions


func _vertical_movement() -> void:
	movement_vector.y += physics_gravity


func _horizontal_movement() -> void:
	input_action = (
		(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		* run_acceleration
	)

	if abs(input_action) < run_acceleration * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		movement_vector.x = move_toward(movement_vector.x, 0, run_stop_force)
	else:
		movement_vector.x += input_action

	movement_vector.x = clamp(movement_vector.x, -run_max_speed, run_max_speed)


func _jump_action():
	if (
		_should_apply_jump_force
		and Input.is_action_pressed("jump")
		and _current_max_jump_force <= max_jump_force
	):
		movement_vector.y = -jump_force
		_current_max_jump_force += jump_force

	if (is_on_floor()) and Input.is_action_just_pressed("jump"):
		movement_vector.y = -jump_force
		_current_max_jump_force += jump_force
		_should_apply_jump_force = true
	elif ! is_on_floor() and Input.is_action_just_pressed("jump") and _enable_double_jump:
		_enable_double_jump = false
		movement_vector.y = -jump_force
		_current_max_jump_force += jump_force
		_should_apply_jump_force = true
		_current_max_jump_force = 0.0
		_is_double_jump = true

	if Input.is_action_just_released("jump"):
		_should_apply_jump_force = false
		_current_max_jump_force = 0.0

	if ! _last_is_on_floor and is_on_floor():
		_enable_double_jump = true
		_is_double_jump = false

	_last_is_on_floor = is_on_floor()
