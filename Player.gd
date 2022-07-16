extends Area2D
export var dieBomb = "res://GameObjects/DieBomb.tscn"
enum DIR { UP, DOWN, LEFT, RIGHT }
# Allow changing the default facing direction in editor
export(DIR) var playerFacing = DIR.RIGHT


var tile_size = 16

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
	if tween.is_active():
		return
	
	#Player movement
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
			take_damage()
			
	if event.is_action_pressed('ui_accept'):
		var dieBomb_spawn = load(dieBomb).instance()
		var obstacles = get_node("/root/main/Obstacles")
		obstacles.add_child(dieBomb_spawn)
#		print("direction of interaction: " + str(direction_of_interaction))
#		var spawn_pos = self.position + direction_of_interaction * Vector2(16.0, 16.0)
		var direction_of_interaction = Vector2((int(playerFacing == DIR.RIGHT) - int(
			playerFacing == DIR.LEFT)), (int(playerFacing == DIR.DOWN) - int(playerFacing == DIR.UP)))
		dieBomb_spawn.position = self.position + direction_of_interaction * Vector2(16.0, 16.0)
#		print("spawning dieBomb at position: " + str(spawn_pos))
		

onready var ray = $RayCast2D

func move(dir):
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		move_tween(dir)
		update_facing(dir)

func update_facing(direction):
	if direction == 'ui_right':
		playerFacing = DIR.RIGHT
	elif direction == 'ui_left':
		playerFacing = DIR.LEFT
	elif direction == 'ui_up':
		playerFacing = DIR.UP
	elif direction == 'ui_down':
		playerFacing = DIR.DOWN

onready var tween = $Tween

export var speed = 3

func move_tween(dir):
	print(self)
	print(position)
	tween.interpolate_property(self, "position",
		position, position + inputs[dir] * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func take_damage():
	health -= 10
	$HealthDisplay.update_healthbar(health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
