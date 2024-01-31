extends MarginContainer

signal play_reload_toggled(state: bool)

func _on_play_reload_toggled(state):
	play_reload_toggled.emit(state)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://src/ui/main.tscn")

func _on_level_lines_left(lines_left:int):
	%LinesAvailableLabel.text = "\\ %s" % lines_left
