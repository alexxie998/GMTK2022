extends Label


var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	
func _process(delta):
	rng.randomize()
	var randomNumbah = rng.randi_range(0, 9999)
	self.text = str(randomNumbah)
	var currentColor = self.get_color("font_color")
	rng.randomize()
	var random_r = rng.randf_range(0.0, 1.0)
	rng.randomize()
	var random_g = rng.randf_range(0.0, 1.0)
	rng.randomize()
	var random_b = rng.randf_range(0.0, 1.0)
	self.add_color_override("font_color", Color(random_r, random_g, random_b, 1.0))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
