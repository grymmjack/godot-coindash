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
	hide()
	position = GJ.randi_fit_rect_in_groups_to_area(
		get_tree(),
		get_node("CollisionShape2D").shape.get_rect().size,
		[ "no_spawn" ],
		Rect2(Vector2.ZERO, screensize)
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
