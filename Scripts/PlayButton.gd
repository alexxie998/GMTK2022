extends MenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_button_pressed")

func _button_pressed():
	get_tree().change_scene("res://Node2D.tscn")
