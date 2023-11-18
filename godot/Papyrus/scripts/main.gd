extends PanelContainer

func _on_level_editor_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_base.tscn")
