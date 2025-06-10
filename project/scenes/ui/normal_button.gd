extends Button
class_name NormalButton

var normal_button_type: int

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

func _on_pressed():
	Logger.info("NormalButton: PRESSED of type %s" % get_name_from_type(normal_button_type))
	MenuManagerGlobal.btn_on_action(normal_button_type)

func _on_focus_entered():
	add_theme_stylebox_override("normal", focus_style)
	set_process(true)

func _on_focus_exited():
	add_theme_stylebox_override("normal", normal_style)
	set_process(false)

func get_name_from_type(type: int) -> String:
	match type:
		NormalButtonType.EXIT: return "EXIT"
		NormalButtonType.SCORE: return "SCORE"
		NormalButtonType.ATTACK_PHY: return "ATTACK_PHY"
		NormalButtonType.SKILLS: return "SKILLS"
		NormalButtonType.SKL_PROJECTILE: return "SKL_PROJECTILE"
		NormalButtonType.COVER: return "COVER"
		NormalButtonType.SKL_SWORD_PILAR: return "SKL_SWORD_PILAR"
		NormalButtonType.SKL_BELLS_AURA: return "SKL_BELLS_AURA"
		NormalButtonType.SKL_LIGHT_CAST: return "SKL_LIGHT_CAST"
		NormalButtonType.SKL_BALL_RANDOM: return "SKL_BALL_RANDOM"
		NormalButtonType.SKL_SURIKEN: return "SKL_SURIKEN"
		NormalButtonType.LOOT_DROP: return "LOOT_DROP"
		NormalButtonType.OPEN_CHEST: return "OPEN_CHEST"
		NormalButtonType.LOOT_CHEST: return "LOOT_CHEST"
		NormalButtonType.TALK: return "TALK"
		NormalButtonType.BUY_1: return "BUY_1"
		NormalButtonType.BUY_2: return "BUY_2"
		NormalButtonType.BUY_3: return "BUY_3"
		NormalButtonType.CAMPUS_1: return "CAMPUS_1"
		NormalButtonType.CAMPUS_2: return "CAMPUS_2"
		NormalButtonType.CAMPUS_3: return "CAMPUS_3"
		NormalButtonType.CAMPUS_4: return "CAMPUS_4"
		NormalButtonType.CAMPUS_5: return "CAMPUS_5"
		_: return "UNKNOWN"
