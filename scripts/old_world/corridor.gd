extends TileMapLayer
class_name Corridor

#Background
@onready var bg_door_izq_closed = $background/bg_door_izq_closed
@onready var bg_door_izq_open = $background/bg_door_izq_open
@onready var bg_door_der_closed = $background/bg_door_der_closed
@onready var bg_door_der_open = $background/bg_door_der_open
@onready var bg_door_top_closed = $background/bg_door_top_closed
@onready var bg_door_top_open = $background/bg_door_top_open
@onready var bg_door_bottom_closed = $background/bg_door_bottom_closed
@onready var bg_door_bottom_open = $background/bg_door_bottom_open


#Walls
@onready var walls_door_bottom_closed = $walls/walls_door_bottom_closed
@onready var walls_door_bottom_open = $walls/walls_door_bottom_open
@onready var walls_door_top_closed = $walls/walls_door_top_closed
@onready var walls_door_top_open = $walls/walls_door_top_open
@onready var walls_door_der_closed = $walls/walls_door_der_closed
@onready var walls_door_der_open = $walls/walls_door_der_open
@onready var walls_door_izq_closed = $walls/walls_door_izq_closed
@onready var walls_door_izq_open = $walls/walls_door_izq_open


#Misc
@onready var platform_top = $misc/platform_top
@onready var platform_down = $misc/platform_down
@onready var bander_top = $misc/bander_top
@onready var bander_down = $misc/bander_down


#Coll
@onready var coll_left_closed = $StaticBody2D/coll_left_closed
@onready var coll_right_closed = $StaticBody2D/coll_right_closed


func load_initial_corridor():
	coll_left_closed.disabled = false
	walls_door_izq_closed.visible = true
	walls_door_izq_open.visible = false
	bg_door_izq_closed.visible = true
	bg_door_izq_open.visible = false
