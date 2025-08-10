extends Node
class_name Scene

"""
Scene Manager for Godot.

This node:
- Loads `.tscn` scene files from a given folder
- Keeps them in memory as a dictionary of name → path
- Switches to a different scene on request

It connects to a global `Event.scene.switch` signal to handle scene changes.

Dependencies:
- `FileLoader` utility for loading resources
- `Event` singleton or autoload with `sound` signals
"""

## Path to the folder containing scenes.
@export var folder_path = "res://Scenes/"

## Map of scene name (lowercase String) → scene file path (String).
var scenes: Dictionary = {}


func _ready() -> void:
	# Scans `folder_path` for `.tscn` files and stores them in `scenes` dictionary
	var paths = FileLoader.traverse_directory(folder_path, false)
	
	for path in paths:
		if path.get_extension().to_lower() == "tscn":
			var scene_name = path.get_file().get_basename().to_lower()
			scenes[scene_name] = path
	
	# Connects scene switch event
	Event.scene.switch.connect(switch_scene)

## Switch the currently active scene to `scene_name`.
## Frees all existing child nodes before loading the new scene.
## @param scene_name - Name of the scene (case-insensitive, no extension).
## @return The root node of the newly loaded scene, or null if not found.
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
