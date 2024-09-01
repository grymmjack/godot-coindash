extends Area2D

var screensize: Vector2 = Vector2.ZERO


func _on_area_entered(area: Area2D) -> void:
	var groups = [ "obstacles", "powerup", "coin", "player_area" ]
	for group in groups:
		if area.is_in_group(group):
			position = Vector2(
				randi_range(0, screensize.x),
				randi_range(150, screensize.y)
			)
			printerr(self.name + " (an " + self.get_class() + ") is colliding with " + group)
