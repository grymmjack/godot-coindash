extends Area2D

var screensize: Vector2 = Vector2.ZERO


# include GJ_LIB
var GJ
func _init() -> void:
	GJ = preload("labs/includes/GJ_LIB.tscn").instantiate()
	add_child(GJ)


func _ready() -> void:
	position = Vector2(
		randi_range(0, int(screensize.x)),
		randi_range(150, int(screensize.y))
	)


func _on_tree_entered() -> void:
	hide()
	position = GJ.randi_fit_rect_in_groups_to_area(
		get_tree(),
		get_node("CollisionShape2D").shape.get_rect().size,
		[ "no_spawn" ],
		Rect2(Vector2.ZERO, screensize)
	)
	show()


func pickup() -> bool:
	# prevents multiple collisions
	$CollisionShape2D.set_deferred("disabled", true)
	# play the sound
	$/root/Main/PowerupSound.play()
	# tween setup for scale and alpha
	var tw = create_tween()
	# tween multiple properties at the same time (parallel)
	tw.set_parallel()
	# set transition function to quadratic curve
	tw.set_trans(Tween.TRANS_QUAD)
	# tween scale
	tw.tween_property(self, "scale", scale * 5, 0.3)
	# tween alpha - modulate:a = alpha
	tw.chain().tween_property(self, "modulate:a", 0.0, 0.3)
	# wait for tween to be finished
	await tw.finished
	# removes node and children when ready at end of current frame
	queue_free()
	# return true since we are awaiting the pickup
	return true


func _on_lifetime_timeout() -> void:
	queue_free()


func animate_in() -> bool:
	$/root/Main/SpawnCoinSound.play()
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUAD)
	self.scale = Vector2(0.2, 0.2)
	tw.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	await tw.finished
	return true
