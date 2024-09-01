# Area2D
# A region of 2D space that detects other CollisionObject2Ds 
# entering or exiting it.
extends Area2D

# custom signals
signal pickup # emit when touch a coin
signal hurt   # emit when touch an obstacle

# speed is set in number of pixels per second
@export var speed: int = 350

# Vector2(0, 0) = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

# vector2 is is always X, Y order
# x = 480, y = 720
var screensize: Vector2 = Vector2(480, 720)


# _process runs every frame
# delta time since the previous frame is not constant.
# delta is in seconds.
func _process(delta: float) -> void:
	# Input.get_vector argument order = -x, +x, -y, +y
	# returns a Vector2
	# positive 1 for x or y if +x/+y, or negative 1 for -x/-y
	# is multiplied to determine direction
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# multiplying against delta makes possible to measure distance in px
	position += velocity * speed * delta
	
	# keep the player from leaving the screen
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	# .length is the length of the vector, NOT the length of it's elements
	# even though a Vector2 is a 2 element array sorta
	if velocity.length() > 0:
		# moving in any direction
		# $ = reference node RELATIVE to node running this script
		# ./ so Player = . and AnimatedSprite2D = ./AnimatedSprite2D
		# If nodes have spaces in name need $"My Node" etc.
		$AnimatedSprite2D.animation = "run"
	else:
		# not moving at all
		$AnimatedSprite2D.animation = "idle"
	# flip sprite horizontally as needed
	if velocity.x != 0:
		# velocity.x != 0 = we are moving in an x direction
		# velocity.x < 0 = boolean - will toggle the correct direction
		# -1 = moving left
		#  0 = not moving (but not considered since x != 0)
		#  1 = moving right
		# so moving left velocity.x < 0 = true so sprite flip_h = true
		# moving right velocity.x < 0 = false so sprite flip_h = false
		# by default flip_h = false, and art is drawn facing right
		$AnimatedSprite2D.flip_h = velocity.x < 0


func start() -> void:
	# calls _process when set to true
	set_process(true)
	# position is a Vector2 and so is screensize
	# so both x and y are set with one operation
	position = Vector2(240, 30)
	scale = Vector2(2, 2)
	$AnimatedSprite2D.animation = "idle"
	$CollisionShape2D.set_deferred("disabled", false)


func die() -> void:
	$AnimatedSprite2D.animation = "hurt"
	# stop calling _process since Player is dead
	set_process(false)


# collision detection
# area is what Player is colliding with
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerup"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()


func _on_spawn_check_area_entered(area):
	return
	var groups = [ "obstacles", "powerup", "coin", "player_area", "hud" ]
	for group in groups:
		print_rich("[color=orange]" + group + "[/color]")
		if area.is_in_group(group):
			position = Vector2(
				randi_range(0, screensize.x),
				randi_range(150, screensize.y)
			)
			printerr(self.name + " (an " + self.get_class() + ") is colliding with " + group)
		else:
			print_rich("[color=green][b]" + group + " -> Player Spawn[/b][/color]")
