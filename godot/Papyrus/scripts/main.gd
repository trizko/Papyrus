extends PanelContainer

func _on_level_editor_button_pressed():
	var level_scene = preload("res://scenes/level_base.tscn")
	var level_scene_instance = level_scene.instantiate()
	level_scene_instance.level_number = 0
	get_tree().root.add_child(level_scene_instance)
