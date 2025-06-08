extends Node3D

@export var amplitude: float = 0.1
@export var base_speed: float = 1.0
@export var speed_variation: float = 0.2

var _base_y: float = 0.0
var _time_passed: float = 0.0
var _offset: float = 0.0
var _actual_speed: float = 1.0

func _ready():
	_base_y = global_position.y
	_offset = randf_range(0.0, TAU)
	_actual_speed = base_speed + randf_range(-speed_variation, speed_variation)

func _process(delta: float) -> void:
	_time_passed += delta * _actual_speed
	global_position.y = _base_y + sin(_time_passed + _offset) * amplitude
