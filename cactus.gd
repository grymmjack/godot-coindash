extends Area2D

var screensize: Vector2 = Vector2.ZERO

# include GJ_LIB
var GJ
func _init() -> void:
	GJ = preload("labs/includes/GJ_LIB.tscn").instantiate()
	add_child(GJ)


func _ready() -> void:
	pass


func _on_tree_entered() -> void:
	var our_rect:Rect2
	var player_rect:Rect2
	hide()
	position = Vector2(
		randf_range(GLOBAL.BOUNDS.Left, GLOBAL.BOUNDS.Right),
		randf_range(GLOBAL.BOUNDS.Top, GLOBAL.BOUNDS.Bottom)
	)
	our_rect = Rect2(
		position.x,
		position.y,
		GJ.image_size($Sprite2D).x,
		GJ.image_size($Sprite2D).y
	)
	player_rect = Rect2(
		$/root/Main/Player.global_position.x,
		$/root/Main/Player.global_position.y,
		GJ.image_size($/root/Main/Player/SpawnCheck).x,
		GJ.image_size($/root/Main/Player/SpawnCheck).y
	)
	while our_rect.intersects(player_rect):
		#printerr("CACTUS INTERSECTS PLAYER")
		position = Vector2(
			randf_range(GLOBAL.BOUNDS.Left, GLOBAL.BOUNDS.Right),
			randf_range(GLOBAL.BOUNDS.Top, GLOBAL.BOUNDS.Bottom)
		)
		our_rect = Rect2(
			position.x,
			position.y,
			GJ.image_size($Sprite2D).x,
			GJ.image_size($Sprite2D).y
		)
	show()


func animate_in() -> bool:
	await get_viewport().get_tree().create_timer(0.03).timeout
	$/root/Main/SpawnCactusSound.play()
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_BOUNCE)
	self.scale = Vector2(1.0, 0.2)
	tw.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	await tw.finished
	return true


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin") || area.is_in_group("powerup"):
		#print_debug(str(area.name).to_upper() + " COLLIDES WITH CACTUS")
		area.position = Vector2(
			randf_range(GLOBAL.BOUNDS.Left, GLOBAL.BOUNDS.Right),
			randf_range(GLOBAL.BOUNDS.Top, GLOBAL.BOUNDS.Bottom)
		)
