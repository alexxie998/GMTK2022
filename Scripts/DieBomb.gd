extends Node2D
export var dieBombExplosion = "res://GameObjects/DieBombExplosion.tscn"

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

func explode():
	#Instantating die bomb explosion sprites
	rng.randomize()
	var randomVal = rng.randi_range(0,5)
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
	#TODO Lod uncomment this when done implementing# obstacles.detect_cell(Vector2(cell_x, cell_y), 
	#	randomVal + 1)
	start_destroy_countdown()
	

	
func start_destroy_countdown():
	destroyTimer.connect("timeout",self,"destroy_self")
	destroyTimer.wait_time = 1
	destroyTimer.one_shot = true
	destroyTimer.start()

func destroy_self():
	print("destroy bomb")
	get_parent().remove_child(self)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
