class_name BuildingOptionButton
extends TextureRect

signal building_selected(building: Building);

@export var button_size: Vector2 = Vector2(64, 64);

var building: Building;

@onready var button: Button = $Button;

func set_building(_building: Building):
	building = _building;

func scale_texture():
	var texture = building.collision_sprite;
	var scale_width = button_size.x / texture.get_width();
	var scale_height = button_size.y / texture.get_height();
	
	var scale_factor = min(scale_width, scale_height);
	
	scale = Vector2(scale_factor, scale_factor);

func update_texture():
	texture = building.collision_sprite;
	button.size = texture.get_size();


func _ready():
	update_texture();

func _on_button_pressed():
	building_selected.emit(building);
