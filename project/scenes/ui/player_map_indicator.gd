extends Sprite2D

@export var jump_distance: float = 4.0
@export var interval: float = 0.3
@export var color: Color = Color.RED  # Cambia el color aquí

var base_position: Vector2
var jumping_up: bool = true
var timer: float = 0.0

func _ready() -> void:
	base_position = position
	modulate = color

func _process(delta: float) -> void:
	timer += delta
	if timer >= interval:
		timer = 0.0
		jumping_up = !jumping_up
		var offset_y = -jump_distance if jumping_up else jump_distance
		position = base_position + Vector2(0, offset_y)
