class_name Interactable
extends Area2D

signal interacted;

@export var enabled: bool = true;

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if not enabled: return;
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interacted.emit();

func _ready():
	input_event.connect(_on_input_event);
