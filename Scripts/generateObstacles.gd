extends TileMap

export var enemy = "res://Enemy.tscn"

var rng = RandomNumberGenerator.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var numEnemies = 0
var illegalCoords = []
var enemyLocations = []
var blockNames = ["Tree"]
var enemyNames = ["Enemy"]
var powerUps = ["speed", "dice"]

func holeCoords(vect):
	illegalCoords.append(vect)
	illegalCoords.append(Vector2(vect.x, vect.y+1))
	illegalCoords.append(Vector2(vect.x+1, vect.y))
	illegalCoords.append(Vector2(vect.x+1, vect.y+1))
	
	
func generateBlocks():
	rng.randomize()
	var randx = rng.randi_range(1, 30)
	var randy = rng.randi_range(1, 30)
	#print("block at ")
	#print(randx)
	#print(randy)
	if !(illegalCoords.has(Vector2(randx, randy))):
		#print("legal")
		illegalCoords.append(Vector2(randx, randy))
		set_cell(randx,randy, tile_set.find_tile_by_name("Tree"))
		#print("success")
		return Vector2(randx, randy)
	#else:
		#print("illegal")

func generateEnemies():
	rng.randomize()
	var randx = rng.randi_range(1, 30)
	var randy = rng.randi_range(1, 30)
	if !(illegalCoords.has(Vector2(randx, randy))):
		#print("legal")
		illegalCoords.append(Vector2(randx, randy))
		set_cell(randx,randy, tile_set.find_tile_by_name("Enemy"))
		#print("success")
		numEnemies += 1
		return Vector2(randx, randy)
	

func blockBreak(pos):
	var dropChance = rng.randf()
	if dropChance <= .5:
		var randPowerup = powerUps[randi() % powerUps.size()]
		print(randPowerup)
	set_cellv(pos, -1)
	pass
	
func enemyKilled(pos):
	set_cellv(pos, -1)
	numEnemies -= 1
	pass

func detectCell(pos, radius):

	var nCollide = false
	var eCollide = false
	var sCollide = false
	var wCollide = false
	
	for n in range(1, radius+1):
		if !nCollide:
			if(get_cell(pos.x, pos.y-n) != -1):
				nCollide = true
				cellType(pos.x, pos.y-n)
		if !eCollide:
			if(get_cell(pos.x+n, pos.y) != -1):
				eCollide = true
				cellType(pos.x+n, pos.y)
		if !sCollide:
			if(get_cell(pos.x, pos.y+n) != -1):
				sCollide = true
				cellType(pos.x, pos.y+n)
		if !wCollide:
			if(get_cell(pos.x-n, pos.y) != -1):
				wCollide = true
				cellType(pos.x-n, pos.y)

func cellType(x, y):
	var explodedCell = get_cell(x, y)
	var cellName = self.tile_set.tile_get_name(explodedCell)
	if(cellName in blockNames):
		blockBreak(Vector2(x, y))
	if(cellName in enemyNames):
		enemyKilled(Vector2(x, y))

# Called when the node enters the scene tree for the first time.
func _ready():
	
	holeCoords(Vector2(5,5))
	holeCoords(Vector2(11,11))
	holeCoords(Vector2(19,19))
	holeCoords(Vector2(25,25))
	holeCoords(Vector2(25,5))
	holeCoords(Vector2(11,19))
	holeCoords(Vector2(19,11))
	holeCoords(Vector2(5,25))
	
	for x in 31:
		illegalCoords.append(Vector2(x, 0))
		illegalCoords.append(Vector2(x, 31))

	for y in 30:
		illegalCoords.append(Vector2(0, y))
		illegalCoords.append(Vector2(31, y))
		
	for x in range(1,4):
		for y in range(1,4):
			illegalCoords.append(Vector2(x,y))
		
	for n in 300:
		generateBlocks()
		
	for n in 15:
		generateEnemies()
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
