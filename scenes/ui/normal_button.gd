extends Button

var normal_style := load("res://scenes/ui/menu_textures/normal_button_normal.tres")
var focus_style := load("res://scenes/ui/menu_textures/normal_button_focus_hover.tres")

var normal_position: Vector2
var shake_timer := 0.0
var direction := 2

func _ready():
	normal_position.x = position.x
	set_process(false)
	focus_mode = Control.FOCUS_ALL

func _process(delta):
	shake_timer += delta
	if shake_timer >= 0.5:
		shake_timer = 0.0
		position.x += direction
		direction *= -1

func _on_focus_entered():
	add_theme_stylebox_override("normal", focus_style)
	set_process(true)

func _on_focus_exited():
	add_theme_stylebox_override("normal", normal_style)
	set_process(false)
