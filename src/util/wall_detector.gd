extends Area2D

class_name WallDetector

# Public vars

var is_wall_detected = false

# Lifecycle


func _ready() -> void:
	connect("body_entered", self, "_on_body_enter")
	connect("body_exited", self, "_on_body_exit")


func _on_body_enter(_body: Area2D) -> void:
	is_wall_detected = true


func _on_body_exit(_body: Area2D) -> void:
	is_wall_detected = false
