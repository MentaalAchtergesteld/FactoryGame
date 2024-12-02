class_name MoveableCamera
extends Node2D

@export var max_speed: float = 5000.0;
@export var zoom_amount: float = 0.5;

@export var building_selection_screen: Screen;

@onready var camera: Camera2D = $Camera2D;
@onready var building_placer: BuildingPlacer = $BuildingPlacer;

func _on_screen_building_selected(building: Building):
	building_placer.start_placing_building(building);

func _on_screen_close(screen: ScreenScene):
	screen.closed.disconnect(_on_screen_close);
	if not (screen is BuildingSelectionScreenScene): return;
	
	var building_selection_screen_node = screen as BuildingSelectionScreenScene;
	building_selection_screen_node.building_selected.disconnect(_on_screen_building_selected);

func open_screen():
	var screen_node = UIManager.open_screen(building_selection_screen);
	if screen_node == null: return;
	if not (screen_node is BuildingSelectionScreenScene):
		push_warning("Supplied scene is not BuildingSelectionScreenScene");
		return;
	
	var building_selection_screen_node = screen_node as BuildingSelectionScreenScene;
	building_selection_screen_node.building_selected.connect(_on_screen_building_selected);
	building_selection_screen_node.closed.connect(_on_screen_close);

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

func _input(event):
	if Input.is_action_just_pressed("open_screen"):
		open_screen();

func _process(delta: float) -> void:
	move_camera(delta);
	zoom_camera(delta);
