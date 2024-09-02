class_name ExecutionOrder
extends Node

# get screensize
@onready var screensize: Vector2 = get_viewport().size

# include GJ_LIB
@onready var GJ: GJ_LIB = preload("../includes/GJ_LIB.tscn").instantiate()

static var call_count:int = 0
static var processed:bool = false
static var notified:bool = false
static var physics_processed:bool = false


func _init() -> void:
	call_count += 1
	print("%d Init" % call_count)


func _notification(what: int) -> void:
	if !notified:
		call_count += 1
		print("%d Notification " % call_count)
		notified = true


func _enter_tree() -> void:
	call_count += 1
	print("%d Enter Tree" % call_count)


func _on_icon_visibility_changed() -> void:
	call_count += 1	
	print("%d Icon Visibility Changed" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _on_icon_tree_entered() -> void:
	call_count += 1
	print("%d Icon Tree Entered" % call_count)
	$Icon.hide()
	print("%d Icon Tree Entered: Hiding Icon" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _on_icon_ready() -> void:
	call_count += 1
	print("%d Icon Ready" % call_count)
	$Icon.position = Vector2(200, 200)
	print("%d Icon Ready - Icon Position:" % call_count)
	print($Icon.position)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _ready() -> void:
	call_count += 1
	print("%d Ready" % call_count)
	#$Icon.position = Vector2(20, 20)
	print("%d Icon Visible? " % [ call_count, $Icon.visible ])
	#if $Icon.position == Vector2(10, 10):
	$Icon.show()
	print("%d Ready - Icon Position:" % call_count)
	print($Icon.position)
	print("%d Ready - Icon Shown" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])

	
	# use GJ_LIB
	#add_child(GJ)
	#print("%d Hiding Icon" % call_count)
	#$Icon.hide()
	#$Icon.queue_free()


func _physics_process(delta: float) -> void:
	if !physics_processed:
		call_count += 1
		print("%d Physics Process" % call_count)
		physics_processed = true
		print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _process(delta: float) -> void:
	if !processed:
		call_count += 1
		print("%d Process" % call_count)
		processed = true
		print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _exit_tree() -> void:
	call_count += 1
	print("%d Exit Tree" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _input(event: InputEvent) -> void:
	call_count += 1
	print("%d Input event" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _unhandled_input(event: InputEvent) -> void:
	call_count += 1
	print("%d Unhandled Input" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _finalize() -> void:
	call_count += 1
	print("%d Finalize" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _on_icon_tree_exited() -> void:
	call_count += 1
	print("%d Icon Tree Exited" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _on_icon_draw() -> void:
	call_count += 1
	print("%d Icon Draw" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])


func _on_icon_hidden() -> void:
	call_count += 1
	print("%d Icon Hidden" % call_count)
	print("%d Icon Visible? %s" % [ call_count, $Icon.visible ])
