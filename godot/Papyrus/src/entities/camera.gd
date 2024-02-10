extends Camera2D

signal rotate_finished()

@onready var animation_player = %AnimationPlayer

func _on_level_trigger_rotatation():
    animation_player.play("Rotate90")
    await animation_player.animation_finished
    rotate_finished.emit()
