extends Area2D

var screensize: Vector2 = Vector2.ZERO


func _ready() -> void:
	$Timer.start(randf_range(3, 8))


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()


func pickup() -> void:
	# prevents multiple collisions
	$CollisionShape2D.set_deferred("disabled", true)
	
	# tween setup for scale and alpha
	var tw = create_tween()
	# tween multiple properties at the same time (parallel)
	tw.set_parallel()
	# set transition function to quadratic curve
	tw.set_trans(Tween.TRANS_QUAD)

	# tween scale
	tw.tween_property(self, "scale", scale * 3, 0.3)	
	# tween alpha - modulate:a = alpha
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	
	# wait for tween to be finished
	await tw.finished
	
	# removes node and children when ready at end of current frame
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	return
	var groups = [ "obstacles", "powerup", "coin", "player_area", "player", "hud" ]
	for group in groups:
		if area.is_in_group(group):
			position = Vector2(
				randi_range(0, screensize.x),
				randi_range(150, screensize.y)
			)
			printerr(self.name + " (an " + self.get_class() + ") is colliding with " + group)
