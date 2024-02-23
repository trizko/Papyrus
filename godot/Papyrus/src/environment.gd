extends Node

var level_json: String

# level modifiers
var bounciness: float = 0.0
var generated_levels: bool = true
var level_number: int = -1

# const base_url: String = "http://localhost:8000"
const base_url: String = "http://165.232.135.113:8000"

func get_route(route: String) -> String:
	var args = {
		"url": base_url,
		"path": route,
	}
	return "{url}/{path}".format(args)
