extends Camera2D

signal rotate()

func _ready():
	var animation_player = $AnimationPlayer
	animation_player.play("Rotate90")
