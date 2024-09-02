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
		printerr("CACTUS Colliding with player")
		me.position = Vector2(
			randi_range(0, screensize.x),
			randi_range(150, screensize.y)
		)
		await get_viewport().get_tree().create_timer(0.2).timeout
		colliding_with_player = GJ.nodes_colliding(me, player)
	print_rich("[color=green]CACTUS NOT Colliding with player[/color]")
	show()
