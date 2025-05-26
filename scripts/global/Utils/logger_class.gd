extends Node
class_name LoggerClass

# Singleton instance
static var instance: LoggerClass

# Variables
var log_file_path: String
var file: FileAccess

func _enter_tree() -> void:
	instance = self

	if Engine.is_editor_hint():
		log_file_path = GlobalConstants.LOG_FILE_DEBUG
		print("Ruta real del archivo log:", ProjectSettings.globalize_path(log_file_path))

	else:
		var exe_path = OS.get_executable_path()
		var exe_dir = exe_path.get_base_dir()
		log_file_path = exe_dir.path_join("log.txt")

	file = FileAccess.open(log_file_path, FileAccess.ModeFlags.WRITE)
	if file == null:
		push_error("LoggerClass: Could not open log file in: %s" % log_file_path)
	else:
		file.seek_end()
		info("LoggerClass initialized. Log file in: %s" % log_file_path)

func write_log(message: String, level: String = "INFO") -> void:
	var dt = Time.get_datetime_dict_from_system()
	var timestamp = "[%02d/%02d/%04d-%02d:%02d:%02d]" % [dt.day, dt.month, dt.year, dt.hour, dt.minute, dt.second]
	var full_message = "%s[%s] %s" % [timestamp, level, message]
	print(full_message)

	if file:
		file.store_line(full_message)
		file.flush()

# Utility methods
func info(message: String) -> void:
	write_log(message, "INFO")

func warning(message: String) -> void:
	write_log(message, "WARNING")

func error(message: String) -> void:
	write_log(message, "ERROR")

func _exit_tree() -> void:
	if file:
		file.close()
