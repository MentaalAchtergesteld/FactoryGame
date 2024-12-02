class_name BuildingSelectionScreenScene
extends ScreenScene

signal building_selected(building: Building);

@export var building_option_scene: PackedScene;

@onready var building_option_grid: GridContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/BuildingOptionGrid;
@onready var building_details: BuildingDetails = $PanelContainer/MarginContainer/VBoxContainer/BuildingDetails;

func _input(event):
	if Input.is_action_just_pressed("close_screen"):
		close();

func update_details(building: Building):
	building_details.building = building;

func _on_option_hovered(building: Building):
	update_details(building);

func _on_option_selected(building: Building):
	building_selected.emit(building);
	close();

func load_buildings():
	var buildings = BuildingManager.get_all();
	
	for child in building_option_grid.get_children():
		building_option_grid.remove_child(child);
	
	for building in buildings:
		var scene = building_option_scene.instantiate();
		if not (scene is BuildingOption):
			print("Supplied scene is not BuildingOption.");
			return;
		
		var new_building_option = scene as BuildingOption;
		
		new_building_option.hovered.connect(_on_option_hovered);
		new_building_option.selected.connect(_on_option_selected);
		
		building_option_grid.add_child(new_building_option);
		new_building_option.building = building;

func open():
	super();
	load_buildings();
