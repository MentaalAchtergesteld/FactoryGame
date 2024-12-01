class_name DestroyLabel
extends Label

@export var destroy_button: DestroyButton;

func _on_is_being_destroyed(time_left: float):
	text = str(time_left).substr(0, 4);

func _on_stopped_destroying():
	text = "";

func _ready():
	if Engine.is_editor_hint(): return;
	destroy_button.is_being_destroyed.connect(_on_is_being_destroyed);
	destroy_button.stopped_destroying.connect(_on_stopped_destroying);
