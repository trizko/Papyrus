extends PanelContainer

var level_scene = preload("res://scenes/level_base.tscn")
var level_scene_instance = level_scene.instantiate()

func _on_level_editor_button_pressed():
	get_tree().root.add_child(level_scene_instance)

func _on_start_button_pressed():
	get_tree().root.add_child(level_scene_instance)
