extends Node
class_name Save
"""
Save Manager for Godot.

This node centralizes savefile management, allowing you to:
- Save dictionary as a json
- Load json back to dictionary
- Reset data in the dictionary

It emits to a global `Event.save` signal system to notify save and load success.

Dependencies:
- `Event` singleton or autoload with `sound` signals
"""

const LOCATION = "user://data.save"
const INITIAL_DATA = {
	"value": 1
}

var data: Dictionary = INITIAL_DATA.duplicate()

## Sets data to the intial values
func reset():
	data = INITIAL_DATA.duplicate()


## Saves the contents of data into the save file at location.
## Emits Event.save.file_saved on success.
func save_json():
	var save_file = FileAccess.open(LOCATION, FileAccess.WRITE)
	if save_file == null:
		push_error("Failed to open file for saving.")
		return
	
	var json_string = JSON.stringify(data)
	save_file.store_line(json_string)
	save_file.close()
	Event.save.file_saved.emit()


## Loads the contents of the save file into data.
## Emits Event.save.file_loaded on success.
func load_json():
	if not FileAccess.file_exists(LOCATION):
		push_warning("No session file found to load.")
		return
	
	var save_file = FileAccess.open(LOCATION, FileAccess.READ)
	if save_file == null:
		push_error("Failed to open file for reading session.")
		return
	
	var json_string = save_file.get_line()
	save_file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		push_error("JSON Parse Error: %s in %s at line %d" % [
			json.get_error_message(), json_string, json.get_error_line()
		])
		return
	
	data = json.data
	Event.save.file_loaded.emit()
