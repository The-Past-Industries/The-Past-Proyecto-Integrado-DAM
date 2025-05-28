extends Camera2D

@export var speed := 300.0
@export var zoom_speed := 0.05
@export var min_zoom := 0.5
@export var max_zoom := 3.0

func _process(delta):
	var input_vector := Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	position += input_vector.normalized() * speed * delta

	# Zoom in/out con Q y E
	var target_zoom := zoom
	if Input.is_key_pressed(KEY_Q):
		target_zoom -= Vector2.ONE * zoom_speed
	elif Input.is_key_pressed(KEY_E):
		target_zoom += Vector2.ONE * zoom_speed

	# Clampear cada componente por separado
	target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
	target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)
	zoom = target_zoom
