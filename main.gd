extends Node

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
@export var playtime = 30

# include GJ_LIB
var GJ
func _init() -> void:
	GJ = preload("labs/includes/GJ_LIB.tscn").instantiate()
	add_child(GJ)

var level: int = 1
var score: int = 0
var time_left: int = 0
var screensize: Vector2 = Vector2.ZERO
var playing: bool = false


func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$HUD.screensize = screensize
	$Player.screensize = screensize
	$Player.hide()


func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coin").size() == 0:
		level += 1
		time_left += 5
		$PowerupTimer.wait_time = 2.0
		$PowerupTimer.start()
		clear_items()
		spawn_items()
		$LevelSound.play()


func _input(event):
	if event.is_action("ui_accept") || event.is_action("ui_start"):
		if !playing and $GameTimer.is_stopped():
			$HUD._on_start_button_pressed()
			get_viewport().set_input_as_handled()
	if event.is_action("ui_cancel") || event.is_action("ui_back"):
		if playing and !$GameTimer.is_stopped():
			game_over()
			get_viewport().set_input_as_handled()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()


func new_game() -> void:
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$GameTimer.start()
	$Player.start()
	$Player.show()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	clear_items()
	spawn_items()


func spawn_items():
	spawn_cactii()
	spawn_coins()


func clear_items():
	get_tree().call_group("coin", "queue_free")
	get_tree().call_group("powerup", "queue_free")
	get_tree().call_group("obstacles", "queue_free")


func spawn_cactii():
	for i in level:
		var c = cactus_scene.instantiate()
		c.screensize = screensize
		add_child(c)
		await get_viewport().get_tree().create_timer(0.03).timeout
		$SpawnCactusSound.play()
		var tw = create_tween()
		tw.set_trans(Tween.TRANS_BOUNCE)
		c.scale = Vector2(1.0, 0.2)
		tw.tween_property(c, "scale", Vector2(1.0, 1.0), 0.2)
		await tw.finished


func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		c.screensize = screensize
		add_child(c)
		await get_viewport().get_tree().create_timer(0.03).timeout
		$SpawnCoinSound.play()
		var tw = create_tween()
		tw.set_trans(Tween.TRANS_QUAD)
		c.scale = Vector2(0.2, 0.2)
		tw.tween_property(c, "scale", Vector2(1.0, 1.0), 0.1)
		await tw.finished


func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func game_over() -> void:
	playing = false
	$HurtSound2.play()
	$HurtSound.play()
	$Player/CollisionShape2D.set_deferred("disabled", true)
	$GameTimer.stop()
	$PowerupTimer.stop()
	$Player.die()
	var tw = create_tween()
	tw.set_parallel(true)
	tw.set_trans(Tween.TRANS_QUAD)
	tw.tween_property($Player, "position", Vector2($Player.position.x, 100), 0.1)
	tw.tween_property($Player, "rotation_degrees", 720.0, 0.1)
	tw.tween_property($Player, "scale", Vector2(7, 7), 0.3)
	await tw.finished
	var tw2 = create_tween()
	tw2.set_parallel(true)
	tw2.set_trans(Tween.TRANS_QUAD)
	tw2.tween_property($Player, "rotation_degrees", -720.0, 0.5)
	tw2.tween_property($Player, "position", Vector2($Player.position.x, screensize.y * 2), 0.5)
	await tw2.finished
	$HUD.show_game_over()
	$EndSound.play()
	clear_items()


func _on_player_pickup(type:String) -> void:
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)


func _on_player_hurt() -> void:
	game_over()


func _on_hud_start_game() -> void:
	new_game()


func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	p.screensize = screensize
	add_child(p)
	$/root/Main/SpawnCoinSound.play()
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUAD)
	p.scale = Vector2(0.2, 0.2)
	tw.tween_property(p, "scale", Vector2(1.0, 1.0), 0.1)
	await tw.finished
	
