@tool
class_name BuildingDetails;
extends PanelContainer

@onready var building_name: Label = $MarginContainer/VBoxContainer/BuildingName;
@onready var building_description: Label = $MarginContainer/VBoxContainer/BuildingDescription;

@export var building: Building:
	set(value):
		building = value;
		if building_name:
			building_name.text = ""  if building == null else building.name;
		if building_description:
			building_description.text = ""  if building == null else building.description;
