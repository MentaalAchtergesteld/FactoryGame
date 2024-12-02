class_name ScreenScene
extends Control

signal opened();
signal closed(screen: ScreenScene);

var resource: Screen;

func set_resource(_resource: Screen):
	resource = _resource;

func open():
	opened.emit();

func close():
	closed.emit(self);
	queue_free();
