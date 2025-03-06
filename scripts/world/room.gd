extends TileMapLayer
class_name Room


func _ready():
	$ambiental_animations/window.play("window")
	$ambiental_animations/window_light.play("window_light")
	$ambiental_animations/chains_long.play("chains_long")
	$ambiental_animations/chains_short.play("chains_short")
	$ambiental_animations/candle.play("candle")
	$ambiental_animations/candle2.play("candle")
	$ambiental_animations/candle3.play("candle")
	$ambiental_animations/candle4.play("candle")
