extends PanelContainer

func _on_start_button_pressed():
	var level_scene = preload("res://scenes/level_base.tscn")
	get_tree().change_scene_to_packed(level_scene)
