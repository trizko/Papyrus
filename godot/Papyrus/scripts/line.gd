extends StaticBody2D

var start_point : Vector2
var end_point : Vector2
var is_drawing : bool = false
var line : Line2D
var collision_shape : CollisionPolygon2D

func _ready():
	line = $Line2D
	line.width = 4
	line.set_default_color(Color.BLACK)
	collision_shape = $CollisionPolygon2D
	collision_shape.build_mode = CollisionPolygon2D.BUILD_SOLIDS

func _process(delta):
	queue_redraw()

func start_drawing(pos):
	is_drawing = true
	start_point = pos
	end_point = pos
	line.points = [start_point]

func finish_drawing():
	is_drawing = false
	update_collision_shape(line.points)

func update_drawing(pos):
	end_point = pos
	line.points = [start_point, end_point]

func update_collision_shape(points: PackedVector2Array) -> void:
	if points.size() >= 2:
		var width_half = line.width / 2.0
		var normals = []
		var polygon = PackedVector2Array()

		# Calculate normals for each segment
		for i in range(points.size() - 1):
			var dir = points[i + 1] - points[i]
			var normal = Vector2(-dir.y, dir.x).normalized() * width_half
			normals.append(normal)

		# Create a polygon shape by offsetting the line points by the normal
		for i in range(points.size() - 1):
			polygon.push_back(points[i] + normals[i])
			polygon.push_back(points[i] - normals[i])

		# Add the last segment's normals
		polygon.push_back(points[points.size() - 1] + normals[normals.size() - 1])
		polygon.push_back(points[points.size() - 1] - normals[normals.size() - 1])

		collision_shape.polygon = polygon

func _draw():
	if is_drawing:
		draw_line(start_point, end_point, Color.BLACK, line.width)
