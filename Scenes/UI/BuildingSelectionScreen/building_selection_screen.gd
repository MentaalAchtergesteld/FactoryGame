class_name BuildingSelectionScreen
extends UIScreen

signal building_selected(building: Building);

var building_option_button_scene: PackedScene = preload("res://Scenes/UI/BuildingSelectionScreen/BuildingOption/building_option_button.tscn");

@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@onready var buildings_container: HBoxContainer = $MarginContainer/PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/BuildingsContainer;

func _on_building_selected(building: Building):
	building_selected.emit(building);
	
	if UIManager.is_screen_open(screen_name):
		UIManager.close_screen();

func remove_building_options():
	for child in buildings_container.get_children():
		buildings_container.remove_child(child);
		if child is BuildingOptionButton:
			var option = child as BuildingOptionButton;
			option.building_selected.disconnect(_on_building_selected);
		child.queue_free();

func load_buildings():
	remove_building_options();
	var buildings = BuildingManager.get_buildings();
	
	for building in buildings:
		var scene = building_option_button_scene.instantiate();
		if not scene is BuildingOptionButton: return;
		var building_option = scene as BuildingOptionButton;
		building_option.set_building(building);
		building_option.building_selected.connect(_on_building_selected);
		buildings_container.add_child(building_option);

func open():
	print("Hi");
	load_buildings();
	animation_player.play("open");

func close():
	animation_player.play("close");
