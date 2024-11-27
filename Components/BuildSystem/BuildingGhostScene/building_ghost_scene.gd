class_name BuildingGhostScene
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D;
var building: Building;
var collision_map: CollisionMap;

func set_building(new_building: Building):
	building = new_building;

func _ready():
	set_texture(building.collision_sprite);
	
	var collision_map = building.get_collision_map()
	if collision_map != null:
		set_collision_map(collision_map);

func set_texture(texture: Texture2D):
	var texture_width = texture.get_width();
	var texture_height = texture.get_height();
	
	var sprite_position_x = texture_width / 2;
	var sprite_position_y = texture_height / 2;
	
	sprite.position.x = sprite_position_x;
	sprite.position.y = sprite_position_y;
	sprite.texture = texture;

func set_collision_map(new_collision_map: CollisionMap):
	if collision_map != null:
		collision_map.queue_free();
	
	collision_map = new_collision_map;
	add_child(collision_map);
	move_child(collision_map, 0);

func can_place() -> bool:
	if collision_map == null: return false;
	return !collision_map.is_colliding();

func place(parent_node: Node2D) -> bool:
	if building == null: return false;
	if !can_place(): return false;
	
	var building_scene := building.get_building();
	if building_scene == null: return false;
	
	building_scene.global_position = global_position;
	
	parent_node.add_child(building_scene);
	return true;
