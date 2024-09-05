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
	$/root/Main/SpawnCactusSound.play()
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_BOUNCE)
	self.scale = Vector2(1.0, 0.2)
	tw.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	await tw.finished
	return true
