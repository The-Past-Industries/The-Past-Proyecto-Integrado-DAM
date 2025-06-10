extends Node
class_name ApiManager
var data
var http := HTTPRequest.new()
var vbox: VBoxContainer

func request_score():
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	http.request(GlobalConstants.API_URL_READ_MATCHES)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code != 200:
		Logger.error("ApiManager: HTTP error: [%s]" % response_code)
		return

	var json = JSON.new()
	if json.parse(body.get_string_from_utf8()) != OK:
		Logger.error("ApiManager: JSON not parseable")
		return

	data = json.data
	
func write_data():
	if not data is Array:
		Logger.error("ApiManager: Result is not an array")
		return

	for i in data.size():
		if i >= vbox.get_child_count():
			break  # No más HBox disponibles

		var hbox = vbox.get_child(i)
		var jugador_data = data[i]

		var valores = [
			jugador_data.get("id_jugador", ""),
			jugador_data.get("fecha_registro", ""),
			jugador_data.get("score", ""),
			jugador_data.get("dinero_total", ""),
			jugador_data.get("dmg_inflingido", ""),
			jugador_data.get("dmg_recibido", "")
		]

		for j in valores.size():
			if j >= hbox.get_child_count():
				break  # No más PanelContainers

			var panel = hbox.get_child(j)
			if panel.get_child_count() == 0:
				continue

			var label = panel.get_child(0)
			if label is Label:
				label.text = str(valores[j])
