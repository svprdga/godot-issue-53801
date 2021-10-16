extends BaseCreature

class_name BaseEnemy

# Export vars

export var decision_min_interval: int = 1000  # milliseconds
export var decision_max_interval: int = 5000
export var decision_idle_probability: float = 0.5

# Public vars

var next_decision_time: int = 0
var invalidate_left_movement: bool = false
var invalidate_right_movement: bool = false

# Lifecycle


func _ready() -> void:
	randomize()
	make_decision()


func _physics_process(_delta: float) -> void:
	detect_obstacles()


func _process(_delta: float) -> void:
	_resolve_decision()


# Override methods


func make_decision() -> void:
	assert(false, "The method make_decision() in BaseEnemy must be overriden.")


func detect_obstacles() -> void:
	assert(false, "The method detect_obstacles() in BaseEnemy must be overriden.")


# Private methods


func _resolve_decision() -> void:
	var now = OS.get_ticks_msec()

	if now >= next_decision_time:
		make_decision()
