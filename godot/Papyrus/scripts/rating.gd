extends VBoxContainer

var fun_stars: Array[ShaderMaterial]
var chal_stars: Array[ShaderMaterial]

func _ready():
	fun_stars = [
		$FunRatingContainer/Stars1.material as ShaderMaterial,
		$FunRatingContainer/Stars2.material as ShaderMaterial,
		$FunRatingContainer/Stars3.material as ShaderMaterial,
		$FunRatingContainer/Stars4.material as ShaderMaterial,
		$FunRatingContainer/Stars5.material as ShaderMaterial,
	]
	chal_stars = [
		$ChalRatingContainer/Stars1.material as ShaderMaterial,
		$ChalRatingContainer/Stars2.material as ShaderMaterial,
		$ChalRatingContainer/Stars3.material as ShaderMaterial,
		$ChalRatingContainer/Stars4.material as ShaderMaterial,
		$ChalRatingContainer/Stars5.material as ShaderMaterial,
	]

func reset_stars(stars):
	for star in stars:
		star.set_shader_parameter("useYellow", false)

func _on_fun_stars_pressed(num):
	reset_stars(fun_stars)
	for i in range(num):
		fun_stars[i].set_shader_parameter("useYellow", true)

func _on_chal_stars_pressed(num):
	reset_stars(chal_stars)
	for i in range(num):
		chal_stars[i].set_shader_parameter("useYellow", true)
