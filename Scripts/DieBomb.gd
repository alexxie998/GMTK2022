extends Node2D
export var dieBombExplosion = "res://GameObjects/DieBombExplosion.tscn"
export var diePowerLevel = 4
export var hasBoot = false
export var hasExecuted = false

var explosionTimer;
var destroyTimer;
var explosionVertical;
var explosionHorizontal;
var explosionRadiusBase = 3
var explosionRadiusMultiplier = 2
var rng = RandomNumberGenerator.new()

func _ready():
	explosionTimer = self.get_child(1)
	destroyTimer = self.get_child(3)
	explosionTimer.connect("timeout",self,"explode")
	explosionTimer.wait_time = 1
	explosionTimer.one_shot = true
	explosionTimer.start()
	
var velocity = Vector2(3.0, 0.0)
func _process(delta):
	if hasBoot:
		velocity = self.get_child(2).move_and_slide(velocity)
		self.position = self.position + velocity
	
func set_power_level(powerLevel):
	diePowerLevel = powerLevel
	match diePowerLevel:
		4:
			self.get_child(0).animation = "d4 roll"
		6:
			self.get_child(0).animation = "d6 roll"
			
func explode():
	#Instantating die bomb explosion sprites
	rng.randomize()
	var randomVal = rng.randi_range(0, diePowerLevel - 1)
	var explodeRadius = explosionRadiusBase + (randomVal * explosionRadiusMultiplier)
	#print('explode bomb with radius: ' + str(randomVal + 1))
	var collisionShape2D = self.get_child(2).get_child(0)
	collisionShape2D.disabled = true
	var explosionVertical_spawn = load(dieBombExplosion).instance()
	self.add_child(explosionVertical_spawn)
	explosionVertical_spawn.scale = explosionVertical_spawn.scale * Vector2(1.0, 
		explodeRadius)
	var explosionHorizontal_spawn = load(dieBombExplosion).instance()
	self.add_child(explosionHorizontal_spawn)
	explosionHorizontal_spawn.scale = explosionHorizontal_spawn.scale * Vector2(
		explodeRadius, 1.0)
	
	#Updating obstacles tilemap
	var obstacles = self.get_parent()
	var cell_x = (self.position.x - 8) / 16;
	var cell_y = (self.position.y - 8) / 16;
	obstacles.detectCell(Vector2(cell_x, cell_y), randomVal + 1)
	start_destroy_countdown()
	

	
func start_destroy_countdown():
	destroyTimer.connect("timeout",self,"destroy_self")
	destroyTimer.wait_time = 1
	destroyTimer.one_shot = true
	destroyTimer.start()

func destroy_self():
	print("destroy bomb")
	get_parent().remove_child(self)

func set_hasBoot(val):
	hasBoot = val
	
func _unhandled_input(event):
	if (!hasExecuted && (event.is_action_pressed('ui_right')
		or event.is_action_pressed('ui_left')
		or event.is_action_pressed('ui_up')
		or event.is_action_pressed('ui_down'))):
			var collisionShape2D = self.get_child(2).get_child(0)
			collisionShape2D.disabled = false
			hasExecuted = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
