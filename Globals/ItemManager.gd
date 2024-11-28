extends Node

var items: Dictionary = {};

func load_from_directory(path: String):
	var dir = DirAccess.open(path);
	if dir == null: return;
	
	for file_name in dir.get_files():
		var file_path = dir.get_current_dir().path_join(file_name);
		var resource = load(file_path);
		if resource is Item:
			var item = resource as Item;
			items[item.id] = item;

func register_item(item: Item):
	items[item.id] = item;

func get_item(id: String) -> Item:
	return items.get(id);

func get_items() -> Array[Item]:
	var values = items.values();
	var items_array: Array[Item];
	for value in values:
		items_array.append(value);
	return items_array;

func _ready():
	#register_item(preload("res://Components/Inventory/Items/coal.tres"));
	load_from_directory("res://Components/Inventory/Items");
