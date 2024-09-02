class_name LabOriginPoint
extends Node

# get screensize
@onready var screensize: Vector2 = get_viewport().size

# include GJ_LIB
@onready var GJ: GJ_LIB = preload("../includes/GJ_LIB.tscn").instantiate()

# prepare sprites
const SPRITE_PATH = "../sprites/"
@onready var coin    = preload(SPRITE_PATH + "coin.tscn").instantiate()
@onready var cactus  = preload(SPRITE_PATH + "cactus.tscn").instantiate()
@onready var powerup = preload(SPRITE_PATH + "powerup.tscn").instantiate()
@onready var player  = preload(SPRITE_PATH + "player.tscn").instantiate()


func _ready() -> void:
	# use GJ_LIB
	add_child(GJ)

	# add coin
	add_child(coin)
	coin.add_to_group("coin")
	coin.position = Vector2(48, 48)

	# add cactus over coin
	add_child(cactus)
	cactus.add_to_group("cactus")
	cactus.position = Vector2(48, 127)
	print(GJ.nodes_colliding(coin, cactus))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
