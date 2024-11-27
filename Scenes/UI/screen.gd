class_name UIScreen
extends Control

@export var screen_name: String = "building_selection";

func open():
	pass

func close():
	pass

func _ready():
	UIManager.register_screen(screen_name, self);
