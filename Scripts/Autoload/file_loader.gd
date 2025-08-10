extends Node
class_name File


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
