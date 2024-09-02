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
	print_rich(
		"%s v%s [color=cyan]LOADED[/color]" % [ GJ_LIB_LOGO, GJ_LIB_VERSION ]
	)


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
	var node_size:Vector2 = image_size(node.find_child("*Sprite*", true))
	return Rect2i(node.global_position, node_size)


func nodes_colliding(node1, node2) -> bool:
	var node1_collision: CollisionShape2D = node1.find_child("*Collision*", true)
	var node2_collision: CollisionShape2D = node2.find_child("*Collision*", true)
	var node1_shape: Shape2D = node1_collision.shape
	var node2_shape: Shape2D = node2_collision.shape
	var node1_transform: Transform2D = node1_collision.get_global_transform()
	var node2_transform: Transform2D = node2_collision.get_global_transform()
	return node1_shape.collide(node1_transform, node2_shape, node2_transform)
