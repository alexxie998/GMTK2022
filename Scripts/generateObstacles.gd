extends TileMap

var rng = RandomNumberGenerator.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var illegalCoords = []

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
	
	pass

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
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
