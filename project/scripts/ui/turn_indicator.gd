extends Node3D
class_name TurnIndicator

@export var float_amplitude: float = 0.1
@export var float_speed: float = 1.0
@export var spin_duration: float = 0.6

var time := 0.0
var base_position: Vector3

var spinning := false
var spin_timer := 0.0
var start_rotation := 0.0
var target_rotation := 0.0

signal rotation_end

func _ready():
	base_position = position

func _process(delta: float) -> void:
	time += delta * float_speed
	position.y = base_position.y + sin(time) * float_amplitude

	if spinning:
		spin_timer += delta
		var t = spin_timer / spin_duration
		if t >= 1.0:
			t = 1.0
			spinning = false
			emit_signal("rotation_end")

		t = 0.5 - 0.5 * cos(t * PI)
		var angle = lerp_angle(start_rotation, target_rotation, t)
		rotation.y = angle

func spin_180() -> void:
	_start_spin(deg_to_rad(180))

func spin_360() -> void:
	spin_180()
	await rotation_end
	spin_180()

func _start_spin(angle_delta: float) -> void:
	if spinning:
		return
	spinning = true
	spin_timer = 0.0
	start_rotation = rotation.y
	target_rotation = start_rotation + angle_delta

func despawn_pop():
	var shrink_time := 0.1
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, shrink_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
