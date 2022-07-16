extends Node2D

var explosionTimer;
var explosionVertical;
var explosionHorizontal;

func _ready():
	explosionTimer = self.get_child(1)
	explosionTimer.connect("timeout",self,"explode")
	explosionTimer.wait_time = 1
	explosionTimer.one_shot = true
	explosionTimer.start()

func explode():
#	explosionVertical = Sprite.new()
#	var texture = ImageTexture.new()
#	var image = Image.new()
#	image.load("res://icon.png")
#	texture.create_from_image(image)
#	$Sprite.texture = texture
#	explosionVertical.texture = "res://Sprites/defaultunused.png"
#	explosionVertical.position = self.position + Vector2(0.0, 16.0)
	print('explode bomb!')
	get_parent().remove_child(self)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
