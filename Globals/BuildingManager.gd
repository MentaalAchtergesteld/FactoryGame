extends Node

var buildings_directory: String = "res://Components/BuildSystem/Buildings/";

var buildings: Dictionary = {};

func load_buildings():
	var dir = DirAccess.open(buildings_directory);
	if dir == null: return;
	
	for file_path in dir.get_files():
		var resource = ResourceLoader.load(file_path);
		
		if resource is Building:
			var building = resource as Building;
			buildings[building.name] = building;

func register_building(building: Building):
	buildings[building.name] = building;

func get_buildings() -> Array[Building]:
	var values = buildings.values();
	var buildings: Array[Building];
	for value in values:
		buildings.append(value);
	return buildings;

func _ready():
	register_building(preload("res://Components/BuildSystem/Buildings/TestBuilding/test_building.tres"));
	register_building(preload("res://Components/BuildSystem/Buildings/BigBoi/big_boi.tres"));
