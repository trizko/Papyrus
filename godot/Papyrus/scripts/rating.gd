extends ColorRect

var fun_stars: Array[ShaderMaterial]
var chal_stars: Array[ShaderMaterial]
var num_fun_stars: int
var num_chal_stars: int
var impossible: bool = false

func _ready():
	fun_stars = [
		$MainContainer/FunRatingContainer/Stars1.material as ShaderMaterial,
		$MainContainer/FunRatingContainer/Stars2.material as ShaderMaterial,
		$MainContainer/FunRatingContainer/Stars3.material as ShaderMaterial,
		$MainContainer/FunRatingContainer/Stars4.material as ShaderMaterial,
		$MainContainer/FunRatingContainer/Stars5.material as ShaderMaterial,
	]
	chal_stars = [
		$MainContainer/ChalRatingContainer/Stars1.material as ShaderMaterial,
		$MainContainer/ChalRatingContainer/Stars2.material as ShaderMaterial,
		$MainContainer/ChalRatingContainer/Stars3.material as ShaderMaterial,
		$MainContainer/ChalRatingContainer/Stars4.material as ShaderMaterial,
		$MainContainer/ChalRatingContainer/Stars5.material as ShaderMaterial,
	]
	
	$HTTPRequest.request_completed.connect(_on_request_completed)

func reset_all():
	reset_stars(fun_stars)
	reset_stars(chal_stars)
	num_fun_stars = 0
	num_chal_stars = 0

func reset_stars(stars):
	for star in stars:
		star.set_shader_parameter("useYellow", false)

func send_rating():
	var url = GlobalEnvironment.get_route("ratings/")
	var data = {
		"fun_rating": num_fun_stars,
		"challenge_rating": num_chal_stars,
		"impossible": impossible,
		"json_level": GlobalEnvironment.level_json,
	}
	var data_json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]

	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, data_json)
	return $HTTPRequest.request_completed

func _on_request_completed(_result, _response_code, _headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print("Response: ", response)

func _on_fun_stars_pressed(num):
	reset_stars(fun_stars)
	for i in range(num):
		fun_stars[i].set_shader_parameter("useYellow", true)
	num_fun_stars = num

func _on_chal_stars_pressed(num):
	reset_stars(chal_stars)
	for i in range(num):
		chal_stars[i].set_shader_parameter("useYellow", true)
	num_chal_stars = num

func _on_submit_button_pressed():
	await send_rating()
	reset_all()
	get_tree().change_scene_to_packed(GlobalEnvironment.level_scene)
