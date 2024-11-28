@tool
class_name Collider
extends Area2D

@onready var is_colliding_sprite: Sprite2D = $IsColliding;
@onready var is_not_colliding_sprite: Sprite2D = $IsNotColliding;

func is_colliding() -> bool:
	return get_overlapping_bodies().size() > 0;
	#var overlapping_bodies = get_overlapping_bodies();
	#if overlapping_bodies.size() > 0:
	#	return true;
	#else:
	#	return false;

func display_collision():
	if is_colliding():
		is_colliding_sprite.visible = true;
		is_not_colliding_sprite.visible = false;
	else:
		is_colliding_sprite.visible = false;
		is_not_colliding_sprite.visible = true;

func _on_body_entered(_body: Node2D):
	display_collision();

func _on_body_exited(_body: Node2D):
	display_collision();

func _ready():
	body_entered.connect(_on_body_entered);
	body_exited.connect(_on_body_exited);
