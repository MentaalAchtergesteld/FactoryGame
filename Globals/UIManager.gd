extends Node

var ui_parent: Control;
var current_screen: Screen;

func _on_current_screen_close(screen: ScreenScene):
	close_current_screen();

func open_screen(screen: Screen) -> ScreenScene:
	if current_screen != null: return null;
	if screen == null: return null;
	
	current_screen = screen;
	
	current_screen.open(ui_parent);
	current_screen.screen.closed.connect(_on_current_screen_close);
	return current_screen.screen;

func get_current_scene() -> ScreenScene:
	return current_screen.screen;

func close_current_screen():
	current_screen.screen.closed.disconnect(_on_current_screen_close);
	current_screen.close();
	current_screen = null;
