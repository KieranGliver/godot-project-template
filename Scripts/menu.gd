extends Node2D
class_name Menu


func _on_play_button_pressed() -> void:
	Event.scene.switch.emit("game")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
