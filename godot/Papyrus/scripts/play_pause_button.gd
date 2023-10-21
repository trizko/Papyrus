extends TextureButton

# Assuming you've set the Play SVG as Normal and Pause as Pressed.
enum State {
	PLAY,
	PAUSE
}

var current_state: State = State.PAUSE

func _ready():
	update_texture()

func update_texture():
	if current_state == State.PLAY:
		self.texture_normal = preload("res://art/images/pause.svg")
	else:
		self.texture_normal = preload("res://art/images/play.svg")

func _on_toggled(button_pressed):
	if current_state == State.PLAY:
		current_state = State.PAUSE
	else:
		current_state = State.PLAY

	update_texture()
