extends Node2D

var line_scene = preload("res://scenes/line.tscn")
var ball_scene = preload("res://scenes/object.tscn")
var current_line_instance = null
var Ball = null

func _ready():
	reset_ball()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			current_line_instance = line_scene.instantiate()
			add_child(current_line_instance)
			current_line_instance.start_drawing(event.position)
		elif current_line_instance:
			current_line_instance.finish_drawing()
			current_line_instance = null
	elif event is InputEventMouseMotion and current_line_instance:
		current_line_instance.update_drawing(event.position)

func _on_button_pressed():
	for line in get_tree().get_nodes_in_group("line"):
		line.queue_free()

func _on_play_reload_button_toggled(button_pressed):
	if (button_pressed):
		Ball.gravity_scale = 1.0
	else:
		Ball.queue_free()
		reset_ball()

func _on_body_entered(body):
	if body.name == "Goal":
		Ball.gravity_scale = 0.0
		Ball.linear_velocity = Vector2.ZERO

func reset_ball():
	Ball = ball_scene.instantiate()
	Ball.set_position($BallStartPosition.position)
	add_child(Ball)
	Ball.gravity_scale = 0.0
	Ball.body_entered.connect(_on_body_entered)
