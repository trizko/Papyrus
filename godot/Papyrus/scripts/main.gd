extends PanelContainer

func _on_normal_mode_button_pressed():
	var level_scene = preload("res://scenes/level_base.tscn")
	GlobalEnvironment.bounciness = 0.0
	get_tree().change_scene_to_packed(level_scene)


func _on_bouncy_mode_pressed():
	var level_scene = preload("res://scenes/level_base.tscn")
	GlobalEnvironment.bounciness = 1.0
	get_tree().change_scene_to_packed(level_scene)
