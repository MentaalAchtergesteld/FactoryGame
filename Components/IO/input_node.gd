class_name InputNode
extends Area2D

signal item_pushed(item: Item, amount: int);

@export var inventory: Inventory;

# Returns the amount that could not be pushed.
func push_item(item: Item, amount: int) -> int:
	if inventory == null: return amount;
	
	var remaining_amount = inventory.add_item(item, amount);
	
	item_pushed.emit(item, remaining_amount);
	return remaining_amount;
