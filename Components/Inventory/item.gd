class_name Item
extends Resource

@export var id: String = "item";
@export var name: String = "Item";
@export_multiline var description: String = "An Item.";
@export var max_stack_size: int = 64;

func clone() -> Item:
	var new_item = Item.new();
	new_item.id = id;
	new_item.name = name;
	new_item.description = description;
	new_item.max_stack_size = max_stack_size;
	return new_item;
