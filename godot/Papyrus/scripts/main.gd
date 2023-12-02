extends PanelContainer

func _on_start_button_pressed():
	get_tree().root.add_child(level_scene_instance)
