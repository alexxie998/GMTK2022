extends Area2D
export var dieBomb = "res://GameObjects/DieBomb.tscn"
export var currentDiePowerLevel = 4

onready var _animation_player = $AnimationPlayer
onready var sprite = $AnimatedSprite
onready var step1 = $step1
onready var step2 = $step2


export var diePowerLevels = [4, 6] #add to this for more die power levels
enum DIR { UP, DOWN, LEFT, RIGHT }
enum STATUS_UPDATE { SPEED, DICE }
# Allow changing the default facing direction in editor
export(DIR) var playerFacing = DIR.RIGHT


var tile_size = 16
var rng = RandomNumberGenerator.new()
onready var collisionShape2D = self.get_child(1)


var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}

var health = 100
var max_health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	pass # Replace with function body.

func _unhandled_input(event):
	var obstacles = get_node("/root/main/Obstacles")
	var currentTile = Vector2((position.x-8)/16, (position.y-8)/16)
	
	if (obstacles.isPowerupSpace(currentTile)):
		rng.randomize()
		var randomNum = randf()
		if randomNum < .5:
			handle_dice_status_update()
		else:
			handle_speed_status_update()
	
	if tween.is_active():
		return
	
	#Player movement
	for dir in inputs.keys():
		if event.is_action(dir):
			move(dir)
			
	if event.is_action_pressed('ui_accept'):
		var dieBomb_spawn = load(dieBomb).instance()
		obstacles.add_child(dieBomb_spawn)
		dieBomb_spawn.set_power_level(currentDiePowerLevel)
		dieBomb_spawn.position = self.position

onready var ray = $RayCast2D

func move(dir):
	update_facing(dir)
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		move_tween(dir)
	else:
		var objectInWay = ray.get_collider()
		if objectInWay.name == "KinematicBody2D-DieBomb":
			print("player facing: " + str(playerFacing))
			var direction_of_interaction = Vector2((int(playerFacing == DIR.RIGHT) - int(
				playerFacing == DIR.LEFT)), (int(playerFacing == DIR.DOWN) - int(playerFacing == DIR.UP)))
			objectInWay.get_parent().kick(direction_of_interaction)
			
	

func update_facing(direction):
	if direction == 'ui_right':
		playerFacing = DIR.RIGHT
		sprite.play("Walk_Right")
	elif direction == 'ui_left':
		playerFacing = DIR.LEFT
		sprite.play("Walk_Left")
	elif direction == 'ui_up':
		playerFacing = DIR.UP
		sprite.play("Walk_Up")
	elif direction == 'ui_down':
		playerFacing = DIR.DOWN
		sprite.play("Walk_Down")

onready var tween = $Tween

export var speed = 3
export var minSpeed = 1
export var maxSpeed = 6

func move_tween(dir):
	#print(self)
	#print(position)
	tween.interpolate_property(self, "position",
		position, position + inputs[dir] * tile_size,
		1.0/speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	var randomNum = rng.randf()
	if randomNum < .5:
		step1.play()
	else:
		step2.play()
	
func apply_status_update(update):
	match typeof(update):
		STATUS_UPDATE.SPEED:
			handle_speed_status_update()
		STATUS_UPDATE.DICE:
			handle_dice_status_update()
			
func handle_speed_status_update():
	rng.randomize()
	var randomNum = rng.randi_range(minSpeed, maxSpeed)
	speed = randomNum

func handle_dice_status_update():
	rng.randomize()
	var randomNum = rng.randi_range(0, diePowerLevels.size() - 1)
	currentDiePowerLevel = diePowerLevels[randomNum]

func take_damage():
	health -= 10
	$HealthDisplay.update_healthbar(health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
