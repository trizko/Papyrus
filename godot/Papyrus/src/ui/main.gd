extends PanelContainer

var game_scene: PackedScene = load("res://src/game.tscn")

func _on_normal_mode_button_pressed():
	GlobalEnvironment.bounciness = 0.0
	get_tree().change_scene_to_packed(game_scene)


func _on_bouncy_mode_button_pressed():
	GlobalEnvironment.bounciness = 1.0
	get_tree().change_scene_to_packed(game_scene)
