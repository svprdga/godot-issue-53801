extends Node2D

# Export vars

export var time_scale = 1.0
export var bottom_death_zone = 0.0

# Onready vars

onready var _player = $Player

# Lifecycle


func _ready() -> void:
	Engine.time_scale = time_scale

	_player.connect("death", self, "_on_Player_death")


func _process(_delta: float) -> void:
	# Check if the player has died falling below the allowed limit
	if _player.position.y > bottom_death_zone:
		_reload_scene()

	# Check to stop the game
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_Player_death():
	_reload_scene()
	
func _reload_scene() -> void:
	get_tree().reload_current_scene()
