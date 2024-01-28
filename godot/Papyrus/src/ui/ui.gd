extends MarginContainer

signal play_reload_toggled(state: bool)

func _on_play_reload_toggled(state):
	play_reload_toggled.emit(state)
