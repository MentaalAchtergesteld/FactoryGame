class_name Screen
extends Resource

@export var screen_scene: PackedScene;

var screen: ScreenScene;

func open(parent_node: Control) -> void:
	screen = screen_scene.instantiate();
	if screen.has_method("set_resource"):
		screen.set_resource(self);
	
	parent_node.add_child(screen);
	
	if screen.has_method("open"):
		screen.open();

func close() -> void:
	if screen != null and screen.has_method("close"):
		screen.close()
