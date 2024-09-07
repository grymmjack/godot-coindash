extends Node

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
@export var playtime = 30

enum GAME_STATE { WAITING, PLAYING, GAME_OVER }
var game_state:int = GAME_STATE.WAITING

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
	game_state = GAME_STATE.WAITING
	screensize = get_viewport().get_visible_rect().size
	%HUD.screensize = screensize
	%Player.screensize = screensize
	%FogOfWar.hide()
	%Player.hide()


func _process(delta: float) -> void:
	delta = delta
	if game_state == GAME_STATE.GAME_OVER:
		return
	if playing and get_tree().get_nodes_in_group("coin").size() == 0:
		new_level()


func _input(event):
	if game_state == GAME_STATE.GAME_OVER:
		return
	if event.is_action("ui_accept") || event.is_action("ui_start"):
		if !playing and %GameTimer.is_stopped():
			%HUD._on_start_button_pressed()
			get_viewport().set_input_as_handled()
	if event.is_action("ui_cancel") || event.is_action("ui_back"):
		if playing and !%GameTimer.is_stopped():
			game_over()
			get_viewport().set_input_as_handled()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()


func new_game() -> void:
	game_state = GAME_STATE.PLAYING
	playing = true
	level = 1
	score = 0
	time_left = playtime
	%GameTimer.start()
	$Player.position = Vector2(screensize.x / 2, screensize.y / 2)
	%Player.start()
	%Player.show()
	%HUD.update_level(level)
	%HUD.update_score(score)
	%HUD.update_timer(time_left)
	clear_items()
	spawn_items()


func new_level() -> void:
	%CoinSound.pitch_scale = 1.0
	level += 1
	%HUD.update_level(level)
	%HUD.update_score(score)
	%HUD.update_timer(time_left)
	time_left += 5
	%PowerupTimer.wait_time = 2.0
	%PowerupTimer.start()
	clear_items()
	spawn_items()
	%LevelSound.play()


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
		c.add_to_group("no_spawn")
		c.screensize = screensize
		set_deferred(c.name, "Cactus")
		add_child(c)
		await c.animate_in()


func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		c.add_to_group("no_spawn")
		c.screensize = screensize
		set_deferred(c.name, "Coin")
		add_child(c)
		await c.animate_in()


func _on_game_timer_timeout() -> void:
	time_left -= 1
	%HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func game_over() -> void:
	game_state = GAME_STATE.GAME_OVER
	playing = false
	%HurtSound2.play()
	%HurtSound.play()
	%Player/CollisionShape2D.set_deferred("disabled", true)
	%GameTimer.stop()
	%PowerupTimer.stop()
	%Player.die()
	var tw = create_tween()
	tw.set_parallel(true)
	tw.set_trans(Tween.TRANS_QUAD)
	tw.tween_property(%Player, "position", Vector2(%Player.position.x, 100), 0.1)
	tw.tween_property(%Player, "rotation_degrees", 720.0, 0.1)
	tw.tween_property(%Player, "scale", Vector2(7, 7), 0.3)
	tw.chain().set_trans(Tween.TRANS_QUAD)
	tw.chain().tween_property(%Player, "rotation_degrees", -screensize.y, 0.5)
	tw.chain().tween_property(%Player, "position", Vector2(%Player.position.x, screensize.y * 2), 0.5)
	await tw.finished
	%HUD.show_game_over()
	%EndSound.play()
	clear_items()

func _on_player_pickup(type:String) -> void:
	match type:
		"coin":
			%CoinSound.pitch_scale += 0.1
			clamp(%CoinSound.pitch_scale, 1.0, 2.0)
			score += 1
			%HUD.update_score(score)
		"powerup":
			time_left += 5
			%HUD.update_timer(time_left)


func _on_player_hurt() -> void:
	game_over()


func _on_hud_start_game() -> void:
	new_game()


func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	p.screensize = screensize
	p.add_to_group("no_spawn")
	set_deferred(p.name, "Powerup")
	add_child(p)
	await p.animate_in()
