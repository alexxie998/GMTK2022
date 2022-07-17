extends Node2D
export var dieBombExplosion = "res://GameObjects/DieBombExplosion.tscn"
export var diePowerLevel = 4
export var kicked = false
export var hasExecuted = false
export var modulateColor = true
onready var bombSound = $bombSound

var explosionTimer;
var destroyTimer;
var turnRedTimer;
var explosionVertical;
var explosionHorizontal;
var explosionRadiusBase = 3
var explosionRadiusMultiplier = 2
var absoluteExplosionRadius = 1
var randomExplosionRadius
var rng = RandomNumberGenerator.new()

func _ready():
	explosionTimer = self.get_child(1)
	destroyTimer = self.get_child(3)
	turnRedTimer = self.get_child(4)
	turnRedTimer.connect("timeout",self,"turnRed")
	turnRedTimer.wait_time = 2.5
	turnRedTimer.one_shot = true
	turnRedTimer.start()
	explosionTimer.connect("timeout",self,"explode")
	explosionTimer.wait_time = 3.75
	explosionTimer.one_shot = true
	bombSound.play()
	explosionTimer.start()
	
var velocity = Vector2(0.0, 0.0)
func _process(delta):
	if modulateColor:
		modulate_color()
	if kicked:
		velocity = self.get_child(2).move_and_slide(velocity)
		self.position = self.position + velocity
		
var modulate_color_val = -0.01
func modulate_color():
	modulate_color_val += modulate_color_val / 50;
	var dieBombAnimation = self.get_child(0)
	var g = dieBombAnimation.modulate.g
	var b = dieBombAnimation.modulate.b
	g += modulate_color_val
	b += modulate_color_val
	
	#to handle limit cases
	if g < 0 or b < 0 or g > 1 or b > 1:
		modulate_color_val = modulate_color_val * -1
		g += modulate_color_val
		b += modulate_color_val
		
	dieBombAnimation.modulate = Color(dieBombAnimation.modulate.r, g, 
		b, dieBombAnimation.modulate.a)
	
func set_power_level(powerLevel):
	diePowerLevel = powerLevel
	match diePowerLevel:
		4:
			self.get_child(0).animation = "d4 roll"
		6:
			self.get_child(0).animation = "d6 roll"
			
func explode():
	#Instantating die bomb explosion sprites
	#print('explode bomb with radius: ' + str(randomVal + 1))
	var collisionShape2D = self.get_child(2).get_child(0)
	collisionShape2D.disabled = true
	var explosionVertical_spawn = load(dieBombExplosion).instance()
	self.add_child(explosionVertical_spawn)
	explosionVertical_spawn.scale = explosionVertical_spawn.scale * Vector2(1.0, 
		absoluteExplosionRadius)
	var explosionHorizontal_spawn = load(dieBombExplosion).instance()
	self.add_child(explosionHorizontal_spawn)
	explosionHorizontal_spawn.scale = explosionHorizontal_spawn.scale * Vector2(
		absoluteExplosionRadius, 1.0)
	
	#Updating obstacles tilemap
	var obstacles = self.get_parent()
	var cell_x = (self.position.x - 8) / 16;
	var cell_y = (self.position.y - 8) / 16;
	obstacles.detectCell(Vector2(cell_x, cell_y), randomExplosionRadius + 1)
	start_destroy_countdown()
	
func start_destroy_countdown():
	destroyTimer.connect("timeout",self,"destroy_self")
	destroyTimer.wait_time = 1
	destroyTimer.one_shot = true
	destroyTimer.start()

func destroy_self():
	print("destroy bomb")
	get_parent().remove_child(self)
	
func _unhandled_input(event):
	if (!hasExecuted && (event.is_action_pressed('ui_right')
		or event.is_action_pressed('ui_left')
		or event.is_action_pressed('ui_up')
		or event.is_action_pressed('ui_down'))):
			var collisionShape2D = self.get_child(2).get_child(0)
			collisionShape2D.disabled = false
			hasExecuted = true

func kick(direction):
	velocity = 3.0 * direction
	kicked = true
	

func turnRed():
	modulateColor = false
	var dieBombAnimation = self.get_child(0)
	dieBombAnimation.modulate = Color(1.0, 0.0, 
		0.0, 1.0)
		
	rng.randomize()
	randomExplosionRadius = rng.randi_range(0, diePowerLevel - 1)
	absoluteExplosionRadius = explosionRadiusBase + (randomExplosionRadius * 
		explosionRadiusMultiplier)
	dieBombAnimation.playing = false
	dieBombAnimation.frame = randomExplosionRadius
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
