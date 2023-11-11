extends TextureButton

enum State {
	PLAY,
	RELOAD
}

var current_state: State = State.RELOAD

func _ready():
	update_texture()

func update_texture():
	if current_state == State.PLAY:
		self.texture_normal = preload("res://art/images/reload.svg")
	else:
		self.texture_normal = preload("res://art/images/play.svg")

func _on_toggled(_button_pressed):
	if current_state == State.PLAY:
		current_state = State.RELOAD
	else:
		current_state = State.PLAY

	update_texture()
