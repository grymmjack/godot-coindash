extends Area2D

@onready var screensize: Vector2 = get_viewport().get_window().size


func _ready() -> void:
	position = Vector2(
		randi_range(0, screensize.x),
		randi_range(150, screensize.y)
	)
