extends Node
class_name File
"""
File utility functions for Godot.

Provides:
- Directory traversal
- Scene instantiation with optional callbacks
- Audio stream player creation
"""

## Recursively or non-recursively get file paths in a directory.
## @param dir_path - The folder path to scan.
## @param nested - If true, searches subfolders recursively.
## @return - List of file paths found.
func traverse_directory(dir_path: String, nested: bool = true) -> Array[String]:
	var dir = DirAccess.open(dir_path)
	var ret: Array[String] = []
	dir.list_dir_begin()
	var element_name = dir.get_next()
	while element_name != "":
		var file_path = dir_path + "/" + element_name
		if dir.current_is_dir():
			if nested:
				ret.append_array(traverse_directory(file_path))
		else:
			ret.append(file_path)
		element_name = dir.get_next()
	return ret

## Load a PackedScene from a file and add it to a parent node.
## Optionally run callbacks before and after adding the node.
## @param path - Path to the `.tscn` file.
## @param parent - Node that will own the instantiated scene.
## @param before_add_child - Runs before adding to the parent.
## @param after_add_child - Runs after adding to the parent.
## @return - The instantiated scene root, or null if loading fails.
func instantiate(
		path: String, 
		parent: Node, 
		before_add_child: Callable = func(node: Node): return,
		after_add_child: Callable = func(node: Node): return,
	) -> Node:
	var packed_scene = ResourceLoader.load(path)
	if packed_scene is not PackedScene:
		return null
	var scene_instance = packed_scene.instantiate()
	before_add_child.call(scene_instance)
	parent.add_child(scene_instance)
	after_add_child.call(scene_instance)
	return scene_instance

## Create and add an AudioStreamPlayer from an audio file.
## @param path - Path to the audio file.
## @param parent - Node that will own the AudioStreamPlayer.
## @param volume - Volume in decibels.
## @return - The created audio player, or null if loading fails.
func player(
		path: String, 
		parent: Node, 
		volume: float = 0.0,
	) -> AudioStreamPlayer:
	var audio_stream = ResourceLoader.load(path)
	if audio_stream is not AudioStream:
		return null
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = audio_stream
	parent.add_child(audio_player)
	audio_player.volume_db = volume
	return audio_player
