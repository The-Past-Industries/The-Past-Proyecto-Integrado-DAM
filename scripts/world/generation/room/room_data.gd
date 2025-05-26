class_name RoomData
extends Resource

@export var level: int
@export var type: RoomType.Type
@export var connections: Array[Vector2i]
@export var distance: int = -1
@export var shown: bool = false
