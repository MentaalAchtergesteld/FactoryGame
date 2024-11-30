class_name DestroyButton
extends Area2D

signal destroyed;

@onready var destroy_progress: Label = $DestroyProgress;
@onready var destroy_timer: Timer = $DestroyTimer;

@export var destroy_time: float = 10.0;
@export var actor_to_destroy: Node;

@export var label_size: float = 16.0:
	set(value):
		label_size = value;
		if destroy_progress:
			destroy_progress.add_theme_font_size_override("font_size", label_size);

var is_destroyed: bool = false;

var is_mouse_insde: bool = false;

func _on_mouse_entered():
	is_mouse_insde = true;

func _on_mouse_exited():
	is_mouse_insde = false;

func _input(event):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or not is_mouse_insde:
		destroy_timer.stop();
		return;
	
	if destroy_timer.is_stopped():
		destroy_timer.start(destroy_time);

func _ready():
	mouse_entered.connect(_on_mouse_entered);
	mouse_exited.connect(_on_mouse_exited);
	
	destroy_progress.add_theme_font_size_override("font_size", label_size);
	
func _on_destroy_timer_timeout():
	is_destroyed = true;
	destroyed.emit();
	actor_to_destroy.queue_free();
	
func _process(delta):
	if Engine.is_editor_hint(): return;
	if not destroy_timer.is_stopped():
		destroy_progress.text = str(destroy_timer.time_left).substr(0, 4);
	else: destroy_progress.text = "";



