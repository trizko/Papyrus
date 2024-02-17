extends Camera2D

signal rotate_finished()

var target_rotation = 0

func _process(_delta):
	position = lerp(position, Vector2(540, 540), 0.5)
	if target_rotation != rotation:
		rotation = lerp_angle(rotation, target_rotation, 0.05)

func _on_level_trigger_rotatation():
	target_rotation -= PI/2
	await get_tree().create_timer(0.5).timeout
	rotate_finished.emit()
