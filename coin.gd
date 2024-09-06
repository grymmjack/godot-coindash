extends Area2D

var screensize: Vector2 = Vector2.ZERO

# include GJ_LIB
var GJ
func _init() -> void:
	GJ = preload("labs/includes/GJ_LIB.tscn").instantiate()
	add_child(GJ)


func _ready() -> void:
	$Timer.start(randf_range(3, 8))


func _on_tree_entered() -> void:
	var our_rect:Rect2
	var player_rect:Rect2
	hide()
	position = Vector2(
		randi_range(0, screensize.x),
		randi_range(150, screensize.y)
	)
	our_rect = Rect2(
		position.x,
		position.y,
		GJ.image_size($AnimatedSprite2D).x,
		GJ.image_size($AnimatedSprite2D).y
	)
	player_rect = Rect2(
		$/root/Main/Player.global_position.x,
		$/root/Main/Player.global_position.y,
		GJ.image_size($/root/Main/Player/SpawnCheck).x,
		GJ.image_size($/root/Main/Player/SpawnCheck).y
	)
	while our_rect.intersects(player_rect):
		printerr("COIN INTERSECTS PLAYER")
		position = Vector2(
			randi_range(0, screensize.x),
			randi_range(150, screensize.y)
		)
		our_rect = Rect2(
			position.x,
			position.y,
			GJ.image_size($AnimatedSprite2D).x,
			GJ.image_size($AnimatedSprite2D).y
		)
	show()


func animate_in() -> bool:
	await get_viewport().get_tree().create_timer(0.03).timeout
	self.scale = Vector2(0.2, 0.2)
	$/root/Main/SpawnCoinSound.play()
	var tw = get_tree(). \
		create_tween(). \
		bind_node(self). \
		set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	await tw.finished
	return true


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()


func pickup() -> bool:
	# prevents multiple collisions
	$CollisionShape2D.set_deferred("disabled", true)
	# stop the timer
	$Timer.stop()
	# play the sound
	$/root/Main/CoinSound.play()
	# tween setup for scale and alpha
	var tw = create_tween()
	# set transition function to quadratic curve
	tw.set_trans(Tween.TRANS_QUAD)
	# tween multiple properties at the same time (parallel)
	tw.set_parallel()
	# tween scale
	tw.tween_property(self, "scale", scale * 3, 0.3)
	# tween alpha - modulate:a = alpha
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	# wait for tween to be finished
	await tw.finished
	# removes node and children when ready at end of current frame
	queue_free()
	# return true since we are awaiting the return
	return true
