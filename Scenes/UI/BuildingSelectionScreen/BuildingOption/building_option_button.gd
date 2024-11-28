@tool
class_name BuildingOptionButton
extends TextureRect

signal building_selected(building: Building);

@export var button_size: Vector2 = Vector2(64, 64);

@export var building: Building:
	set = set_building;

@export var force_update: bool = false:
	set(value):
		force_update = false;
		if building != null: update_texture();

@onready var button: Button = $Button;


func set_building(_building: Building):
	building = _building;
	update_texture();

#func scale_texture():
#	var _texture = building.collision_sprite;
#	var scale_width = button_size.x / _texture.get_width();
#	var scale_height = button_size.y / _texture.get_height();
#	
#	var scale_factor = min(scale_width, scale_height);
	
func update_texture():
	if building == null: return;
	texture = building.collision_sprite;
	if texture == null: return;
#	scale_texture();


func _ready():
	update_texture();

func _on_button_pressed():
	building_selected.emit(building);
