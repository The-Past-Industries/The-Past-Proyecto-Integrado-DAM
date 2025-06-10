extends AnimatedSprite2D
class_name EnemyVisor

func _ready():
	MenuManagerGlobal.enemy_visor_sprite = self

func set_enemy_sprite():
	if !CombatManagerGlobal.enemy_is_boss:
		sprite_frames = EntityManagerGlobal.enemy.body_instance.sprite_frames
		_set_heigh_by_name(EntityManagerGlobal.enemy.sprite_name)
		play("idle")
	else:
		sprite_frames = EntityManagerGlobal.boss.body_instance.sprite_frames

func _set_heigh_by_name(sprite_frames_name: String):
	var size: float
	var pos_y: float
	var pos_x: float
	
	Logger.info("EnemyVisor: Setting enemy sprite frames [%s]" % sprite_frames_name)
	
	# ASIMOLE
	if sprite_frames_name.contains("asimole_"):
		size = 2
		pos_y = 80
		if flip_h: pos_x = 50
		else: pos_x = 154

	# BARREL
	elif sprite_frames_name.contains("barrel_"):
		size = 4
		pos_y = 0
		if flip_h: pos_x = 94
		else: pos_x = 114
		
	elif sprite_frames_name.contains("bat_"):
		size = 7
		pos_y = 94
		if flip_h: pos_x = 94
		else: pos_x = 114
		
	elif sprite_frames_name.contains("cactuar_"):
		size = 5
		pos_y = 0
		if flip_h: pos_x = 53
		else: pos_x = 146
		
	elif sprite_frames_name.contains("creeps_"):
		size = 5
		pos_y = 25
		if flip_h: pos_x = 110
		else: pos_x = 100
		
	elif sprite_frames_name.contains("defencer_"):
		size = 8
		pos_y = -227
		if flip_h: pos_x = 94
		else: pos_x = 107
		
	elif sprite_frames_name.contains("demonpot_"):
		size = 3
		pos_y = 100
		if flip_h: pos_x = 101
		else: pos_x = 103
		
	elif sprite_frames_name.contains("dragonfly_"):
		size = 6
		pos_y = 74
		if flip_h: pos_x = 92
		else: pos_x = 109
		
	elif sprite_frames_name.contains("dummy_"):
		size = 6
		pos_y = 60
		if flip_h: pos_x = 92
		else: pos_x = 109
		
	elif sprite_frames_name.contains("element_"):
		size = 4
		pos_y = 60
		if flip_h: pos_x = 92
		else: pos_x = 109
		
	elif sprite_frames_name.contains("genie_"):
		size = 6
		pos_y = 100
		if flip_h: pos_x = 116
		else: pos_x = 91
		
	elif sprite_frames_name.contains("hobgob_"):
		size = 8
		pos_y = -258
		if flip_h: pos_x = 115
		else: pos_x = 91
		
	elif sprite_frames_name.contains("jackolantern_"):
		size = 4
		pos_y = -33
		if flip_h: pos_x = 115
		else: pos_x = 99
		
	elif sprite_frames_name.contains("lantern_"):
		size = 6
		pos_y = 24
		if flip_h: pos_x = 102
		else: pos_x = 105
		
	elif sprite_frames_name.contains("mechasphere_"):
		size = 1.5
		pos_y = 112
		if flip_h: pos_x = 105
		else: pos_x = 104
		
	elif sprite_frames_name.contains("slime_"):
		size = 7
		pos_y = -243
		if flip_h: pos_x = 106
		else: pos_x = 100
		
	elif sprite_frames_name.contains("spore_"):
		size = 7
		pos_y = -217
		if flip_h: pos_x = 114
		else: pos_x = 100
		
	elif sprite_frames_name.contains("treant_"):
		size = 3
		pos_y = 17
		if flip_h: pos_x = 93
		else: pos_x = 111
		
	elif sprite_frames_name.contains("twofaced_"):
		size = 5
		pos_y = 32
		if flip_h: pos_x = 106
		else: pos_x = 104
	
	scale = Vector2(size,size)
	position = Vector2(pos_x, pos_y)
	Logger.info("EnemyVisor: Setting position at [%s] and size [%f]" % [position, size])
	
