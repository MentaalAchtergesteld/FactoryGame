class_name Building
extends Resource

@export_group("Building Details")
@export var name: String = "Building";
@export_multiline var description: String = "A Building.";

@export_group("Building")
@export var building_scene: PackedScene; 

@export_group("Collision")
@export var collision_sprite: Texture2D;
@export var collision_map: PackedScene;

var ghost_scene: PackedScene = preload("res://Components/BuildSystem/BuildingGhostScene/building_ghost_scene.tscn")

func clone(building: Building) -> Building:
	var new_building = Building.new();
	new_building.name = building.name;
	new_building.description = building.description;
	new_building.building_scene = building.building_scene;
	new_building.collision_sprite = building.collision_sprite;
	new_building.collision_map = building.collision_map;
	
	return new_building;

func get_building() -> BuildingScene:
	var scene = building_scene.instantiate();
	
	if scene is BuildingScene:
		return scene;
	else:
		return null;

func get_collision_map() -> CollisionMap:
	var scene = collision_map.instantiate();
	
	if scene is CollisionMap:
		return scene;
	else:
		return null;

func get_ghost() -> BuildingGhostScene:
	var scene = ghost_scene.instantiate();
	
	if not scene is BuildingGhostScene: return null;
	
	var ghost_scene = scene as BuildingGhostScene;
	ghost_scene.set_building(clone(self));
	
	return ghost_scene;

