extends PanelContainer

var game_scene: PackedScene = load("res://src/game.tscn")

func _on_normal_mode_button_pressed():
	GlobalEnvironment.generated_levels = false
	get_tree().change_scene_to_packed(game_scene)

func _on_generated_mode_button_pressed():
	GlobalEnvironment.generated_levels = true
	get_tree().change_scene_to_packed(game_scene)
