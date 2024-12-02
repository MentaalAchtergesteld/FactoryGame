extends Node

var buildings: Dictionary = {};

func load_from_directory(path: String):
	var dir = DirAccess.open(path);
	if dir == null: return;
	
	for directory in dir.get_directories():
		var file_name = directory.to_snake_case() + ".tres";
		var file_path = dir.get_current_dir().path_join(directory).path_join(file_name);
		var resource = load(file_path);
		if resource is Building:
			var building = resource as Building;
			buildings[building.id] = building;

func register_building(building: Building):
	buildings[building.id] = building;

func get_all() -> Array[Building]:
	var values = buildings.values();
	var buildings_array: Array[Building];
	for value in values:
		buildings_array.append(value);
	return buildings_array;

func _ready():
	load_from_directory("res://Resources/Buildings");
