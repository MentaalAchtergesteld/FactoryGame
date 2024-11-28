class_name MoveableCamera
extends Node2D

@export var max_speed: float = 5000.0;
@export var zoom_amount: float = 0.5;

@onready var camera: Camera2D = $Camera2D;

var building_selection_screen_name = "building_selection";

func move_camera(delta: float) -> void:
	var movement_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	movement_vector = movement_vector.normalized();
	position += movement_vector * max_speed * delta;

func zoom_camera(delta: float) -> void:
	var zoom_direction = 0;
	if Input.is_action_just_released("zoom_in"):
		zoom_direction += 1;
	elif Input.is_action_just_released("zoom_out"):
		zoom_direction -= 1;
	
	camera.zoom += Vector2(zoom_amount, zoom_amount) * zoom_direction * delta;

func _process(delta: float) -> void:
	move_camera(delta);
	zoom_camera(delta);

func _on_building_selected(building: Building):
	$BuildingPlacer.start_placing_building(building);

func _ready():
	var building_selection_screen = UIManager.get_screen(building_selection_screen_name);
	if building_selection_screen is BuildingSelectionScreen:
		building_selection_screen.building_selected.connect(_on_building_selected);
