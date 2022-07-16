extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#Health bar
var greenBar = preload("res://sprites/Healthbar.png")
onready var healthbar = $HealthBar 

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() and get_parent().get("max_health"):
		healthbar.max_value = get_parent().max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = 0

func update_healthbar(value):
	print("updating health")
	print(healthbar.value)
	healthbar.value = value
