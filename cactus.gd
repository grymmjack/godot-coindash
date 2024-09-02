extends Area2D

var screensize: Vector2 = Vector2.ZERO


func _ready() -> void:
	position = Vector2(
		randi_range(0, screensize.x),
		randi_range(150, screensize.y)
	)
