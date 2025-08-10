extends Node
class_name EventBus

var scene = SceneEvents.new()
var sound = SoundEvents.new()

# Scene-related events
class SceneEvents:
	signal switch(scene_name: String)

# Sound-related events
class SoundEvents:
	signal play(audio_name: String)
	signal stop(audio_name: String)
	signal stop_all()
	signal set_volume(value: float)
