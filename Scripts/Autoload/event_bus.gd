extends Node
class_name EventBus

var scene = SceneEvents.new()
var sound = SoundEvents.new()
var save = SaveEvents.new()

# Scene-related events
class SceneEvents:
	signal switch(scene_name: String)

# Sound-related events
class SoundEvents:
	signal play(audio_name: String)
	signal stop(audio_name: String)
	signal stop_all()
	signal set_volume(value: float)

# Save-related events
class SaveEvents:
	signal file_saved()
	signal file_loaded()
