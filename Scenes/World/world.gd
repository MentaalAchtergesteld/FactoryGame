extends Node2D

@onready var ui_parent: Control = $"CanvasLayer/UIParent";

func _ready():
	UIManager.ui_parent = ui_parent;
