@tool
class_name BuildingPlacer
extends Node2D

@export_range(16, 2056) var max_place_range: float = 256:
	set(value):
		max_place_range = value;
		queue_redraw();

@export var grid_size: Vector2 = Vector2(16, 16);

@export_group("Debug")
@export var debug_building: Building;
@export var debug: bool = false;

var current_ghost: BuildingGhostScene;
var is_placing_building: bool = false;

func _input(_event):
	if Input.is_action_pressed("place_building"):
		try_place_building();
	elif Input.is_action_just_pressed("end_placing_building"):
		end_placing_building();
	
	if Input.is_action_just_pressed("rotate_building") && current_ghost != null:
		current_ghost.rotate_clockwise();
	
	if !debug: return;
	if debug_building == null: return;
	if Input.is_action_just_pressed("start_placing_building"):
		start_placing_building(debug_building);

func get_mouse_grid_position() -> Vector2:
	var mouse_position = get_global_mouse_position();
	return floor(mouse_position / grid_size  + Vector2(0.5, 0.5)) * grid_size;

func set_ghost(building: Building):
	if current_ghost != null: remove_ghost();
	current_ghost = building.get_ghost();
	add_child(current_ghost);

func remove_ghost():
	if current_ghost == null: return;
	current_ghost.queue_free();
	current_ghost = null;

func start_placing_building(building: Building) -> void:
	if is_placing_building: return;
	is_placing_building = true;
	set_ghost(building);

func end_placing_building() -> void:
	if !is_placing_building: return;
	
	is_placing_building = false;
	remove_ghost();

func try_place_building() -> bool:
	if !is_placing_building: return false;
	
	var mouse_position = get_global_mouse_position();
	if mouse_position.distance_squared_to(global_position) > max_place_range * max_place_range:
		return false;
	
	if current_ghost.place(get_tree().root.get_node("World")):
		#end_placing_building();
		return true;
	else:
		return false;

func _process(_delta):
	if Engine.is_editor_hint(): return;
	if current_ghost == null: return;
	
	var ghost_size = current_ghost.get_size();
	current_ghost.global_position = get_mouse_grid_position() - floor(ghost_size / 2) * grid_size;

func _draw():
	if !debug && !Engine.is_editor_hint(): return;
	var fill_color = Color(1, 1, 1, 0.3);
	var outline_color = Color(1, 1, 1, 1);
	draw_circle(Vector2.ZERO, max_place_range, fill_color);
	draw_arc(Vector2.ZERO, max_place_range, 0, TAU, 64, outline_color, 1);
