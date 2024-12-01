class_name DestroyButton
extends Area2D

signal destroyed;
signal is_being_destroyed(time_left: float);
signal stopped_destroying;

@onready var destroy_timer: Timer = $DestroyTimer;

@export var destroy_time: float = 10.0;
@export var actor_to_destroy: Node;

var is_destroyed: bool = false;
var is_mouse_insde: bool = false;

func _on_mouse_entered():
	is_mouse_insde = true;

func _on_mouse_exited():
	is_mouse_insde = false;

func _input(event):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or not is_mouse_insde:
		destroy_timer.stop();
		stopped_destroying.emit();
		return;
	
	if destroy_timer.is_stopped():
		destroy_timer.start(destroy_time);

func _ready():
	mouse_entered.connect(_on_mouse_entered);
	mouse_exited.connect(_on_mouse_exited);

func _on_destroy_timer_timeout():
	is_destroyed = true;
	destroyed.emit();
	actor_to_destroy.queue_free();
	
func _process(delta):
	if Engine.is_editor_hint(): return;
	if not destroy_timer.is_stopped():
		is_being_destroyed.emit(destroy_timer.time_left);



