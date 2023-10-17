extends Node2D

var rigidbody_scene = preload("res://scenes/pencil.tscn")
var is_drawing = false

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			is_drawing = true
			draw_at_point(event.global_position)
		else:
			is_drawing = false
	elif is_drawing and event is InputEventMouseMotion:
		draw_at_point(event.global_position)

func draw_at_point(pos):
	var body = rigidbody_scene.instantiate()
	body.global_position = pos
	add_child(body)
