extends Node

var line_scene = preload("res://scenes/line.tscn")
var ball_scene = preload("res://scenes/object.tscn")
var obstacle_scene = preload("res://scenes/obstacle.tscn")
var goal_scene = preload("res://scenes/goal.tscn")
var line_count = 0
var level_number = null
var max_lines = null
var ball_start_position = null
var current_line_instance = null
var Ball = null

func _ready():
	# parse level data
	var json_as_text = FileAccess.get_file_as_string("res://levels.json")
	var levels = JSON.parse_string(json_as_text)
	var level_data = levels[level_number]

	# get and set line count
	max_lines = level_data["max_lines"]

	# get ball starting position and instantiate ball
	ball_start_position = Vector2(
		level_data["ball"]["position_x"],
		level_data["ball"]["position_y"],
	)
	reset_ball(ball_start_position)

	# get and instantiate all obstacles
	for o in level_data["obstacles"]:
		var obstacle = obstacle_scene.instantiate()
		obstacle.start_point = Vector2(o["start_point_x"], o["start_point_y"])
		obstacle.end_point = Vector2(o["end_point_x"], o["end_point_y"])
		add_child(obstacle)

	# initialize goal
	var goal = goal_scene.instantiate()
	goal.position = Vector2(
		level_data["goal"]["position_x"],
		level_data["goal"]["position_y"],
	)
	add_child(goal)

func _unhandled_input(event):
	if line_count >= max_lines:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			current_line_instance = line_scene.instantiate()
			add_child(current_line_instance)
			current_line_instance.start_drawing(event.position)
		elif current_line_instance:
			current_line_instance.finish_drawing()
			current_line_instance = null
			line_count = line_count + 1
	elif event is InputEventMouseMotion and current_line_instance:
		current_line_instance.update_drawing(event.position)

func _on_clear_button_pressed():
	line_count = 0
	for line in get_tree().get_nodes_in_group("line"):
		line.queue_free()

func _on_play_reload_button_toggled(button_pressed):
	if (button_pressed):
		Ball.gravity_scale = 1.0
	else:
		Ball.queue_free()
		reset_ball(ball_start_position)

func _on_body_entered(body):
	if body.name == "Goal":
		Ball.gravity_scale = 0.0
		Ball.linear_velocity = Vector2.ZERO
		reset_level(level_number + 1)

func reset_ball(pos):
	Ball = ball_scene.instantiate()
	Ball.set_position(pos)
	add_child(Ball)
	Ball.gravity_scale = 0.0
	Ball.body_entered.connect(_on_body_entered)

func reset_level(level_num):
	var level_scene = preload("res://scenes/level_base.tscn")
	var level_scene_instance = level_scene.instantiate()
	level_scene_instance.level_number = level_num
	get_tree().root.add_child(level_scene_instance)
