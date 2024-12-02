@tool
class_name BuildingOption
extends PanelContainer

signal selected(building: Building);
signal hovered(building: Building);

@onready var texture_rect: TextureRect = $TextureRect;
@onready var button: Button = $Button;

@export var building: Building:
	set(value):
		building = value;
		set_texture();

func set_texture():
	if building == null: return;
	texture_rect.texture = building.collision_sprite;

func _on_button_pressed():
	selected.emit(building);

func _on_button_mouse_entered():
	hovered.emit(building);
