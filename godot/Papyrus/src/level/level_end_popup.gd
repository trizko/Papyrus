extends Control

signal next_level_pressed

func _on_button_pressed():
	emit_signal("next_level_pressed")
