extends StaticBody2D

const LINE_WIDTH = 2

# Member variables
var start_point : Vector2
var end_point : Vector2
var is_drawing : bool = false
var line : Line2D

func _ready():
	line = $Line2D
	line.width = 2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# when the mouse button is pressed down, start drawing
				is_drawing = true
				start_point = event.position
				line.points = [start_point]
			else:
				# when the mouse button is released, stop drawing
				is_drawing = false
	elif event is InputEventMouseMotion and is_drawing:
		# while dragging, update the end point and draw the line
		end_point = event.position
		line.points = [start_point, end_point]

func _draw():
	if is_drawing:
		draw_line(start_point, end_point, line.color, LINE_WIDTH)
