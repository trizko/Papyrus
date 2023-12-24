extends Node

var level_scene = preload("res://scenes/level_base.tscn")
var rating_scene = preload("res://scenes/rating.tscn")

var level_json: String

const base_url: String = "http://localhost:8000"

func get_route(route: String) -> String:
	var args = {
		"url": base_url,
		"path": route,
	}
	return "{url}/{path}".format(args)
