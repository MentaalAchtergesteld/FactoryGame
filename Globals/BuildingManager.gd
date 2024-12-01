extends Node

var buildings: Dictionary = {};

func register_building(building: Building):
	buildings[building.id] = building;

func get_buildings() -> Array[Building]:
	var values = buildings.values();
	var buildings_array: Array[Building];
	for value in values:
		buildings_array.append(value);
	return buildings_array;

func _ready():
	register_building(preload("res://Resources/Buildings/TestBuilding/test_building.tres"));
	register_building(preload("res://Resources/Buildings/BigBoi/big_boi.tres"));
	register_building(preload("res://Resources/Buildings/BadBelt/bad_belt.tres"));
