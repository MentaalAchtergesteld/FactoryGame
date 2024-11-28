class_name BuildingGhostScene
extends Node2D

@onready var rotation_point: Node2D = $RotationPoint;
@onready var sprite: Sprite2D = $RotationPoint/Sprite2D;
@export var building: Building;
var collision_map: CollisionMap;

var ghost_rotation: int = 0;

func position_to_grid(position: Vector2, grid_size: Vector2) -> Vector2:
	return floor(position / grid_size) * grid_size;

func set_building(new_building: Building):
	building = new_building;

func _ready():
	set_texture(building.collision_sprite);
	
	var new_collision_map = building.get_collision_map()
	if new_collision_map != null:
		set_collision_map(new_collision_map);
	update_rotation()

func rotate_clockwise():
	ghost_rotation += 1;
	if ghost_rotation > 3: ghost_rotation = 0;
	update_rotation();

func update_rotation():
	var collision_map_size = Vector2(collision_map.get_used_rect().size * collision_map.tile_set.tile_size);
	match ghost_rotation:
		0:
			rotation_point.rotation_degrees = 0;
			rotation_point.position = Vector2(0, 0);
		1:
			rotation_point.rotation_degrees = 90;
			rotation_point.position = Vector2(collision_map_size.x, 0);
		2:
			rotation_point.rotation_degrees = 180;
			rotation_point.position = Vector2(collision_map_size.x, collision_map_size.y);
		3:
			rotation_point.rotation_degrees = 270;
			rotation_point.position = Vector2(0, collision_map_size.y);

func set_texture(texture: Texture2D):
	var texture_width = texture.get_width();
	var texture_height = texture.get_height();
	
	var sprite_position_x = texture_width / 2.;
	var sprite_position_y = texture_height / 2.;
	
	sprite.position.x = sprite_position_x;
	sprite.position.y = sprite_position_y;
	sprite.texture = texture;

func set_collision_map(new_collision_map: CollisionMap):
	if collision_map != null:
		collision_map.queue_free();
	
	collision_map = new_collision_map;
	var collision_map_size = Vector2(collision_map.get_used_rect().size);
	collision_map.position = -rotation_point.position;
	rotation_point.add_child(collision_map);
	rotation_point.move_child(collision_map, 0);

func get_size() -> Vector2:
	if collision_map == null: return Vector2(0, 0);
	return Vector2(collision_map.get_used_rect().size);

func can_place() -> bool:
	if collision_map == null: return false;
	return !collision_map.is_colliding();

func place(parent_node: Node2D) -> bool:
	if building == null: return false;
	if !can_place(): return false;
	
	var building_scene := building.get_building();
	if building_scene == null: return false;
	
	var collision_map_size = Vector2(collision_map.get_used_rect().size * collision_map.tile_set.tile_size);
	
	building_scene.global_position = global_position;
	building_scene.global_rotation = rotation_point.global_rotation;
	building_scene.global_position += rotation_point.position;
	
	parent_node.add_child(building_scene);
	return true;
