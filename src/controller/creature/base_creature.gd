extends KinematicBody2D

class_name BaseCreature

# Export vars

export var stats_attack: int = 5
export var stats_defense: int = 3
export var stats_max_health: int = 10

export var run_acceleration: float = 100
export var run_max_speed: float = 100
export var run_stop_force: float = 1000

export var physics_gravity: float = 17

export var damage_hit_force: float = 650.0
export var damage_mitigate_amount: float = 0.85

export var death_hit_force: float = 50.0
export var death_mitigate_amount: float = 0.4

# Public vars

var input_action: float = 0.0
var movement_vector: Vector2 = Vector2()
var health: int = 0

var is_receiving_damage: bool = false
var is_dying: bool = false

# Lifecycle


func _ready() -> void:
	health = stats_max_health

func _physics_process(_delta: float) -> void:
	_mitigate_damage()


# Public methods


func is_receive_damage_disabled() -> bool:
	return is_dying or is_receiving_damage


# Public methods


func receive_damage(body: KinematicBody2D) -> void:
	if is_receive_damage_disabled():
		return

	var contact_vector = (position - body.position).normalized()
	var creature = body as BaseCreature

	health -= creature.stats_attack - stats_defense

	if health < 1:
		health = 0

	if health < 1:
		var vec = contact_vector * death_hit_force
		movement_vector = vec
		is_dying = true
	else:
		var vec = contact_vector * damage_hit_force
		print(vec)
		movement_vector = vec
		is_receiving_damage = true

	after_receive_damage()


# Override methods


func after_receive_damage() -> void:
	assert(false, "The method after_receive_damage() in BaseCreature must be overriden.")

# Private methods

func _mitigate_damage() -> void:
	if is_receiving_damage:
		movement_vector *= damage_mitigate_amount
	elif is_dying:
		movement_vector *= death_mitigate_amount
