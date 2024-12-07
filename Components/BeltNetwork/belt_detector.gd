class_name BeltDetector
extends Node2D

@onready var top: Area2D = $Top;
@onready var right: Area2D = $Right;
@onready var bottom: Area2D = $Bottom;
@onready var left: Area2D = $Left;

func make_array_unique(array: Array) -> Array:
	var unique_values = [];
	
	for value in array:
		if !unique_values.has(value):
			unique_values.append(value);
	
	return unique_values;

func find_belt_network() -> BeltNetwork:
	var found_networks: Array[BeltNetwork] = [];
	
	for detector in [top, right, bottom, left]:
		detector = detector as Area2D;
		var overlapping_bodies = detector.get_overlapping_bodies();
		
		var belts: Array[Belt] = overlapping_bodies.filter(func(body): body is Belt);
		
		for belt in belts:
			if belt.belt_network != null:
				found_networks.append(belt.belt_network);
	
	found_networks = make_array_unique(found_networks);
	
	var main_network = found_networks.pop_back();
	
	for network in found_networks:
		main_network = main_network.join(network);
	return null;
