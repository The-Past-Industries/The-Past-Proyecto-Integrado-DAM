extends Panel

@onready var color_rect = $MarginContainer/ColorRect
@onready var label = $Label

const MARGIN := 10

@export var player_stats : bool
@onready var entity
	
func _process(_delta: float) -> void:
	if !entity:
		if WorldManagerGlobal.cur_cell_instance.room_data.type == RoomType.COMMON:
			entity = EntityManagerGlobal.enemy
		elif WorldManagerGlobal.cur_cell_instance.room_data.type == RoomType.BOSS:
			entity = EntityManagerGlobal.boss
	
	if entity != null:
		var hp_max = entity.stats_manager.get_stat_value(StatType.HEALTH_MAX)
		var hp_pts = entity.stats_manager.get_stat_value(StatType.HEALTH_PTS)

		label.text = "%.0f / %.0f" % [hp_pts, hp_max]
		if hp_max <= 0:
			return

		var percent = clamp(hp_pts / hp_max, 0.0, 1.0)

		var full_width = color_rect.get_parent().size.x - MARGIN * 2
		var bar_width = full_width * percent

		color_rect.position.x = MARGIN
		color_rect.size.x = bar_width
