extends CanvasLayer

signal start_game

@onready var screensize: Vector2 = get_viewport().get_window().size


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
	$/root/Main.game_state = $/root/Main.GAME_STATE.WAITING
