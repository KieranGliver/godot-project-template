extends Node
class_name Sound
"""
Sound Manager for Godot.

This node centralizes audio playback, allowing you to:
- Preload audio files from a specified folder
- Play, stop, and stop all sounds
- Adjust the master volume for all active sounds
- Automatically clean up finished sounds

It connects to a global `Event.sound` signal system to react to play/stop/volume events.

Dependencies:
- `FileLoader` utility for loading resources
- `Event` singleton or autoload with `sound` signals
"""

## Path to the folder containing audio files.
@export var folder_path = "res://Audio/"


var audio: Dictionary = {}  ## Map of audio name (String) -> audio file path (String)

## Master volume (in decibels) applied to all sounds.
## Setting this triggers `_on_volume_change` to update active players.
var master_volume: float = 0.0:
	set(value):
		master_volume = value
		_on_volume_change(value)


func _ready() -> void:
	var audio_paths = FileLoader.traverse_directory(folder_path)
	
	# Scans `folder_path` for `.import` files and populates `audio`.
	for path in audio_paths:
		if path.get_extension().to_lower() == "import":
			var audio_name = path.get_file().to_lower()
			audio_name = audio_name.substr(0, audio_name.length()-11)
			audio[audio_name] = path.substr(0, path.length()-7)
	
	# Connects Event.sound signals to this node’s functions.
	Event.sound.play.connect(play)
	Event.sound.stop.connect(stop)
	Event.sound.stop_all.connect(stop_all)
	Event.sound.set_volume.connect(set_volume)

## Updates the `volume_db` of all active AudioStreamPlayers to match `master_volume`.
## @param value - New volume in decibels.
func _on_volume_change(value: float) -> void:
	var children = get_children()
	for i in children:
		i.volume_db = value


## Called when an AudioStreamPlayer finishes playback.
## Removes any finished audio players.
func _on_audio_stream_finished():
	close_finished()


## Plays an audio stream by its name from `audio`.
## @param audio_name - Name of the audio without extension.
## @param play - If true, starts playback immediately.
## @return The created AudioStreamPlayer or null if not found.
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


## Stops and frees all active audio players.
func stop_all():
	var children = get_children()
	for i in children:
		i.queue_free()


## Stops and frees audio players whose name starts with `child_name`.
## @param child_name - Prefix to match against AudioStreamPlayer node names.
func stop(child_name: String):
	var children = get_children()
	var filter = func(child): return child.name.begins_with(child_name)
	var filtered_children = children.filter(filter)
	for i in filtered_children:
		i.queue_free()

## Sets the master volume for all current and future sounds.
## @param value - New volume in decibels.
func set_volume(value: float):
	master_volume = value


## Removes any AudioStreamPlayers that are no longer playing.
func close_finished():
	var children = get_children()
	for i in children:
		if !i.playing:
			i.queue_free()
