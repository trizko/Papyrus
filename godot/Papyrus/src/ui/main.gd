extends PanelContainer

func _on_normal_mode_button_pressed():
	var game_scene = preload("res://src/game.tscn")
	GlobalEnvironment.bounciness = 0.0
	get_tree().change_scene_to_packed(game_scene)


func _on_bouncy_mode_button_pressed():
	var game_scene = preload("res://src/game.tscn")
	GlobalEnvironment.bounciness = 1.0
	get_tree().change_scene_to_packed(game_scene)
