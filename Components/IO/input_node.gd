class_name InputNode
extends Area2D

signal item_received(item: Item, amount: int);

@export var inventory: Inventory;

# Returns the total count that could be received.
func can_receive(item: Item, count: int) -> int:
	return count - inventory.add_item(item, count, true);

# Returns the total count that could not be received.
func receive(item: Item, count: int) -> int:
	if inventory == null: return count;
	
	var remaining = inventory.add_item(item, count);
	
	item_received.emit(item, count-remaining);
	return remaining;
