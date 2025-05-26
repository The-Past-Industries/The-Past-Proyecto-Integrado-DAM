extends Node

var actual_room: int = 0
var last_instance: String = ""

func increase_room():
	actual_room += 1

func next_instance() -> String:
	print(last_instance)
	if last_instance == "room":
		last_instance = "corridor"
		return "corridor_" + str(actual_room)
	else:
		increase_room()
		last_instance = "room"
		return "room_" + str(actual_room)
