extends Node

var ui_parent: Control;
var screens: Dictionary = {};
var current_screen: UIScreen;

func register_screen(key: String, screen: UIScreen):
	screens[key] = screen;

func get_screen(key: String) -> UIScreen:
	return screens.get(key);

func is_screen_open(screen_key: String) -> bool:
	var screen = screens[screen_key];
	if screen == null: return false;
	if screen == current_screen: return true;
	return false;

func open_screen(screen_key: String) -> bool:
	if ui_parent == null: return false;
	if current_screen != null: return false
	
	var screen = screens[screen_key];
	if screen == null: return false;
	
	current_screen = screen;
	screen.open();
	return true;

func close_screen() -> bool:
	if current_screen == null: return false;
	current_screen.close();
	current_screen = null;
	return true;
