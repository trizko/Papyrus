extends Node2D

signal lines_left(lines_left: int)
signal trigger_rotatation()
signal reset_camera()

var line_scene = preload("res://src/entities/line.tscn")
var ball_scene = preload("res://src/entities/ball/object.tscn")
var obstacle_scene = preload("res://src/entities/obstacle.tscn")
var goal_scene = preload("res://src/entities/goal.tscn")
var line_count = 0
var max_lines = 0
var ball_start_position = null
var current_line_instance = null
var Ball = null
var rotation_index = 0
var rotation_map = [
	Vector2.DOWN,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.LEFT,
]
var last_touched_obstacle = null

func _ready():
	# read level data from api
	# %HTTPRequest.request_completed.connect(_on_request_completed)
	# %HTTPRequest.request(GlobalEnvironment.get_route("levels/"))
	
	# read level data from file
	var level_json = FileAccess.get_file_as_bytes("res://src/level/level.json")
	level_json = JSON.parse_string(level_json.get_string_from_utf8())
	_initialize_level(level_json)

func _unhandled_input(event):
	var world_position = get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if line_count >= max_lines:
			return
		if event.pressed:
			current_line_instance = line_scene.instantiate()
			add_child(current_line_instance)
			current_line_instance.start_drawing(world_position)
		elif current_line_instance:
			current_line_instance.finish_drawing()
			current_line_instance = null
			line_count = line_count + 1
			lines_left.emit(max_lines - line_count)
	elif event is InputEventMouseMotion and current_line_instance:
		current_line_instance.update_drawing(world_position)

func _on_body_entered(body):
	if body.is_in_group("obstacle") and last_touched_obstacle != body:
		last_touched_obstacle = body
		stop_ball()
		trigger_rotatation.emit()
	if body.name == "Goal":
		stop_ball()
		reset_level()

func reset_ball(pos):
	last_touched_obstacle = null
	Ball = ball_scene.instantiate()
	Ball.set_position(pos)
	add_child(Ball)
	Ball.gravity_scale = 0.0
	Ball.physics_material_override.bounce = GlobalEnvironment.bounciness
	Ball.body_entered.connect(_on_body_entered)
	reset_rotation()

func reset_rotation():
	rotation_index = 0
	PhysicsServer2D.area_set_param(
		get_viewport().world_2d.space,
		PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR,
		rotation_map[rotation_index]
	)
	reset_camera.emit()

func reset_level():
	var rating_scene = load("res://src/ui/rating.tscn")
	get_tree().call_deferred("change_scene_to_packed", rating_scene)

func stop_ball():
	Ball.gravity_scale = 0.0
	Ball.linear_velocity = Vector2.ZERO

func _on_request_completed(_result, _response_code, _headers, body):
	var level_json = JSON.parse_string(body.get_string_from_utf8())
	if (GlobalEnvironment.bounciness == 1.0):
		level_json["game_mode"] = "bouncy"
	else:
		level_json["game_mode"] = "normal"
	GlobalEnvironment.level_json = JSON.stringify(level_json)
	_initialize_level(level_json)

func _initialize_level(level_json):
	# parse level data
	var level_data = level_json

	# get and set line count
	max_lines = level_data["max_lines"]
	lines_left.emit(max_lines)

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

func _on_ui_skip_button_pressed():
	reset_level()

func _on_level_end_popup_next_level_pressed():
	reset_level()

func _on_back_button_pressed():
	var main_scene = preload("res://src/ui/main.tscn")
	get_tree().change_scene_to_packed(main_scene)

func _on_ui_play_reload_toggled(state: bool):
	if (state):
		Ball.gravity_scale = 1.0
	else:
		Ball.queue_free()
		reset_ball(ball_start_position)

func _on_ui_undo_pressed():
	var lines = get_tree().get_nodes_in_group("line")
	if len(lines) > 0:
		var line = lines.pop_back()
		line_count = len(lines)
		lines_left.emit(max_lines - line_count)
		line.queue_free()

func _on_camera_rotate_finished():
	rotation_index = (rotation_index + 1) % 4
	PhysicsServer2D.area_set_param(
		get_viewport().world_2d.space,
		PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR,
		rotation_map[rotation_index]
	)
	Ball.gravity_scale = 1.0
