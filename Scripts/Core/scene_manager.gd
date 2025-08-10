extends Node
class_name Scene

@export var folder_path = "res://Scenes/"

var scenes: Dictionary = {}


func _ready() -> void:
	var paths = FileLoader.traverse_directory(folder_path, false)
	
	for path in paths:
		if path.get_extension().to_lower() == "tscn":
			var scene_name = path.get_file().get_basename().to_lower()
			scenes[scene_name] = path
	
	Event.scene.switch.connect(switch_scene)


func switch_scene(scene_name: String) -> Node:
	for child in get_children():
		child.queue_free()
	var keys = scenes.keys()
	if keys.has(scene_name):
		var instance = FileLoader.instantiate(scenes[scene_name], self)
		return instance
	else:
		push_warning("Scene not found: " + scene_name)
		return null
