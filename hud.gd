extends CanvasLayer

signal start_game

@onready var screensize: Vector2 = get_viewport().get_window().size


func update_score(value: int) -> void:
	$MarginContainer/Score.text = str(value)


func update_timer(value: int) -> void:
	$MarginContainer/Time.text = str(value)


func update_level(value: int) -> void:
	var tw = get_tree().create_tween()
	tw.set_parallel(true)
	tw.set_trans(Tween.TRANS_SPRING)
	tw.tween_property($MarginContainer, "scale", Vector2(1.1, 1.1), 0.1)
	tw.chain().tween_property($MarginContainer, "scale", Vector2(1.0, 1.0), 0.1)
	await tw.finished
	$MarginContainer/Level.text = str(value)


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
	show_message("[p][center][shake rate=30.0 level=40 connected=1][color=#FF6699FF]GAME OVER[/color][/shake][/center][/p]")
	await $Timer.timeout
	$StartButton.show()
	$Message.text = "[p][center][wave amp=50.0 freq=15.0 connected=1]COIN DASH![/wave][/center][/p]"
	$Message.show()
	$/root/Main.game_state = $/root/Main.GAME_STATE.WAITING
