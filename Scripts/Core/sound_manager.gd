extends Node
class_name Sound

@export var folder_path = "res://Audio/"

## Stores dictionary of audio names to audio paths
var audio: Dictionary = {}
var master_volume: float = 0.0:
	set(value):
		master_volume = value
		_on_volume_change(value)


func _ready() -> void:
	var audio_paths = FileLoader.traverse_directory(folder_path)
	
	for path in audio_paths:
		if path.get_extension().to_lower() == "import":
			var audio_name = path.get_file().to_lower()
			audio_name = audio_name.substr(0, audio_name.length()-11)
			audio[audio_name] = path.substr(0, path.length()-7)
	
	Event.sound.play.connect(play)
	Event.sound.stop.connect(stop)
	Event.sound.stop_all.connect(stop_all)
	Event.sound.set_volume.connect(set_volume)


func _on_volume_change(value: float) -> void:
	var children = get_children()
	for i in children:
		i.volume_db = value


func _on_audio_stream_finished():
	close_finished()


func play(audio_name: String, play: bool = true) -> AudioStreamPlayer:
	var keys = audio.keys()
	if keys.has(audio_name):
		var player = FileLoader.player(audio[audio_name], self, master_volume)
		player.name = audio_name
		player.finished.connect(_on_audio_stream_finished)
		if play:
			player.play()
		return player
	push_warning("Failed at finding audio stream " + audio_name)
	return null


func stop_all():
	var children = get_children()
	for i in children:
		i.queue_free()


func stop(child_name: String):
	var children = get_children()
	var filter = func(child): return child.name.begins_with(child_name)
	var filtered_children = children.filter(filter)
	for i in filtered_children:
		i.queue_free()


func set_volume(value: float):
	master_volume = value


func close_finished():
	var children = get_children()
	for i in children:
		if !i.playing:
			i.queue_free()
