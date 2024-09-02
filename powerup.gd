extends Area2D

var screensize: Vector2 = Vector2.ZERO

# include GJ_LIB
var GJ
func _init() -> void:
	GJ = preload("labs/includes/GJ_LIB.tscn").instantiate()
	add_child(GJ)


func _ready() -> void:
	position = Vector2(
		randi_range(0, screensize.x),
		randi_range(150, screensize.y)
	)


func _on_tree_entered() -> void:
	hide()
	var me = $"."
	var player = get_parent().get_node("Player").get_node("SpawnCheck")
	me.position = Vector2(
		randi_range(0, screensize.x),
		randi_range(150, screensize.y)
	)
	var colliding_with_player:bool = GJ.nodes_colliding(me, player)
	while colliding_with_player:
		printerr("POWERUP Colliding with player")
		me.position = Vector2(
			randi_range(0, screensize.x),
			randi_range(150, screensize.y)
		)
		await get_viewport().get_tree().create_timer(0.2).timeout
		colliding_with_player = GJ.nodes_colliding(me, player)
	print_rich("[color=green]POWERUP NOT Colliding with player[/color]")
	show()


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
	tw.tween_property(self, "scale", scale * 5, 0.3)	
	# tween alpha - modulate:a = alpha
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	
	# wait for tween to be finished
	await tw.finished
	
	# removes node and children when ready at end of current frame
	queue_free()


func _on_lifetime_timeout() -> void:
	queue_free()
