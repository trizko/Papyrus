extends TextureButton

signal play_reload_toggled(state: bool)

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

func _on_toggled(toggled_on):
	if current_state == State.PLAY:
		current_state = State.RELOAD
	else:
		current_state = State.PLAY

	play_reload_toggled.emit(toggled_on)

	update_texture()
