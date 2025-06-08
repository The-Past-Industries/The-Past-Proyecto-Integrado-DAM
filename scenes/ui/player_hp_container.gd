extends Panel

@onready var color_rect = $MarginContainer/ColorRect
@onready var label = $Label

const MARGIN := 10

@export var player_stats : bool
@onready var entity = EntityManagerGlobal.player

func _process(_delta: float) -> void:
	if entity != null:
		var stats = entity.stats_manager
		var hp_max = stats.get_stat_value(StatType.HEALTH_MAX)
		var hp_pts = stats.get_stat_value(StatType.HEALTH_PTS)

		label.text = "%.0f / %.0f" % [hp_pts, hp_max]
		if hp_max <= 0:
			return

		var percent = clamp(hp_pts / hp_max, 0.0, 1.0)

		var full_width = color_rect.get_parent().size.x - MARGIN * 2
		var bar_width = full_width * percent

		color_rect.position.x = MARGIN
		color_rect.size.x = bar_width
