"""
GJ_LIB (grymmjack's Godot Library)
Contains frequently used bits and bobs I find useful

@version 0.1
@author grymmjack (grymmjack@gmail.com)
"""
extends Node
class_name GJ_LIB

const GJ_LIB_VERSION:float = 0.1
const GJ_LIB_LOGO:String = "🟨🟧🟥 [color=white][b]GJ_LIB[/b][/color]"


func _enter_tree() -> void:
	#print_rich(k
		#"%s v%s [color=cyan]LOADED[/color]" % [ GJ_LIB_LOGO, GJ_LIB_VERSION ]
	#)
	pass


func get_rects_in_group(tree:SceneTree, group:String) -> Array[Rect2]:
	var rects_returned:Array[Rect2]
	var size:Vector2 = Vector2.ZERO
	var position:Vector2 = Vector2.ZERO
	var child:Node2D
	var texture:Texture2D
	var rect:Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)
	# walk nodes in group to get their rects
	var nodes_in_group:Array = tree.get_nodes_in_group(group)
	for node in nodes_in_group:
		if node is Sprite2D:
			texture = node.texture
			size = texture.get_size()
			position = node.position
		if node is AnimatedSprite2D:
			texture = node.sprite_frames.get_frame_texture(node.animation, node.frame)
			size = texture.get_size()
			position = node.position
		if node is Area2D:
			child = node.find_child("*Collision*", true)
			size = child.shape.get_rect().size
			position = child.position
		if node is Control:
			size = node.rect_size()
			position = node.position
		if node is TileMap:
			size = node.get_used_rect().size
			position = node.position
		# add to rect storage
		rect = Rect2(position, size)
		rects_returned.append(rect)
	return rects_returned


func randi_fit_rect_in_groups_to_area(tree:SceneTree, size:Vector2, groups:Array, area:Rect2) -> Vector2:
	var rects:Array[Rect2] = []
	var all_rects:Array[Rect2] = []
	var test_rect:Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)
	var fit_position:Vector2 = Vector2.ZERO
	var safe_positions:Array[Vector2]
	var no_intersect_all_groups:bool = false
	var bitmap_mask: Sprite2D

	for group in groups:
		rects = get_rects_in_group(tree, group)
		all_rects.append_array(rects)

	bitmap_mask = bitmap_of_rects(rects, Color("#000000"), Color("#FFFFFF"), area.size)
	print(bitmap_mask)
	bitmap_mask.position = Vector2(0, 0)
	#$/root.add_child(bitmap_mask)
	breakpoint
	#var no_intersect_test_rect:bool = true
	#for y in range(0, area.size.y, size[1]):
		#for x in range(0, area.size.x, size[0]):
			#test_rect = Rect2(x, y, size[0], size[1])
			#for rect in all_rects:
				#if rect.intersects(test_rect):
					#printerr(test_rect, rect)
					#no_intersect_test_rect = false
			#if no_intersect_test_rect:
				#safe_positions.append(Vector2(x, y))
	#var random_safe_position:int
	#if safe_positions.size():
		#random_safe_position = randi_range(0, safe_positions.size())
		#print(safe_positions[random_safe_position])
		#return safe_positions[random_safe_position]
	#else:
	return Vector2.ZERO


func bitmap_of_rects(rects:Array[Rect2], trans: Color, fill: Color, size: Vector2) -> Sprite2D:
	var sprite:Sprite2D = Sprite2D.new()
	var img:Image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	var txt:ImageTexture = ImageTexture.new()
	var t2d:Texture2D

	# fill base with transparent color
	img.fill(trans)
	txt.create_from_image(img)

	# fill rects
	for rect in rects:
		draw_rect_on_image(img, fill, rect.size.x, rect.size.y)

	sprite.texture = txt
	img.save_png("user://bitmap_mask.png")
	return sprite


func draw_rect_on_image(image: Image, color: Color, width: int, height: int) -> Image:
	var start_x = (image.get_width() - width) / 2
	var start_y = (image.get_height() - height) / 2

	# Draw the rectangle
	for x in range(width):
		for y in range(height):
			image.set_pixel(start_x + x, start_y + y, color)

	return image


func delay(duration: float, callback: Callable) -> void:
	get_tree().create_timer(duration).connect("timeout", callback)


func image_size(node, anim: String = "default", frame_num: int = 0) -> Vector2:
	if node is Sprite2D:
		var texture = node.texture
		return texture.get_size()
	elif node is AnimatedSprite2D:
		var texture = node.sprite_frames.get_frame_texture(anim, frame_num)
		return texture.get_size()
	elif node is Control:
		return node.rect_size
	elif node is TileMap:
		return node.get_used_rect().size
	else:
		return Vector2.ZERO


func image_rect(node: Node2D, anim: String = "default", frame_num: int = 0) -> Rect2i:
	var node_size:Vector2 = image_size(node.find_child("*Sprite*", true), anim, frame_num)
	return Rect2i(node.global_position, node_size)


func nodes_colliding(node1, node2) -> bool:
	var node1_collision: CollisionShape2D = node1.find_child("*Collision*", true)
	var node2_collision: CollisionShape2D = node2.find_child("*Collision*", true)
	var node1_shape: Shape2D = node1_collision.shape
	var node2_shape: Shape2D = node2_collision.shape
	var node1_transform: Transform2D = node1_collision.get_global_transform()
	var node2_transform: Transform2D = node2_collision.get_global_transform()
	return node1_shape.collide(node1_transform, node2_shape, node2_transform)
