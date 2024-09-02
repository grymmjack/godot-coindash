extends CanvasLayer

signal start_game
var screensize: Vector2 = Vector2.ZERO


func update_score(value: int) -> void:
	$MarginContainer/Score.text = str(value)


func update_timer(value: int) -> void:
	$MarginContainer/Time.text = str(value)


func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$Timer.start()


func _on_timer_timeout() -> void:
	$Message.hide()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Message.hide()
	start_game.emit()


func show_game_over() -> void:
	show_message("[p][center][shake rate=30.0 level=40 connected=1][color=#FF6699FF]Game Over[/color][/shake][/center][/p]")
	await $Timer.timeout
	$StartButton.show()
	$Message.text = "[p][center][wave amp=50.0 freq=15.0 connected=1]Coin Dash![/wave][/center][/p]"
	$Message.show()


#func _on_spawn_check_area_entered(area):
	#var groups = [ "obstacles", "powerup", "coin" ]
	#for group in groups:
		#if area.is_in_group(group):
			#area.position = Vector2(
				#randi_range(0, screensize.x),
				#randi_range(100, screensize.y)
			#)
			#printerr(self.name + " (an " + self.get_class() + ") is colliding with " + group)
