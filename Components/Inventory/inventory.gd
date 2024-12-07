@tool
class_name Inventory
extends Node

enum UpdateType {
	Add,
	Remove
}

signal inventory_updated(slot_index: int, item_stack: ItemStack, update_type: UpdateType);
signal inventory_resized(new_size: int);

@export var inventory_size: int = 8:
	set(value):
		inventory_size = value;
		resize_inventory();

#@export var override_stack_size: bool = false:
#	set(value):
#		override_stack_size = value;
#		notify_property_list_changed();

#var max_stack_size: int = 32;

var inventory: Array[ItemStack];

#func _get_property_list() -> Array:
#	var properties = [];
#	
#	if override_stack_size:
#		properties.append({
#			"name": "max_stack_size",
#			"type": TYPE_INT,
#			"hint": PROPERTY_HINT_RANGE,
#			"hint_string": "1,999,1",
#			"usage": PROPERTY_USAGE_DEFAULT
#		})
#	
#	return properties;

func _ready():
	resize_inventory();

func resize_inventory():
	inventory.resize(inventory_size);
	inventory_resized.emit(inventory_size);

func debug() -> String:
	var string = "";
	
	string += "Inventory:\n";
	
	for slot_index in range(inventory.size()):
		string += str(slot_index) + ": ";
		
		var stack = inventory[slot_index];
		
		if stack == null:
			string += "Empty\n";
		else:
			string += str(stack.count) + " " + stack.item.name + "(s)\n";
	
	return string;

# Returns the count of items that could NOT be added.
func add_item(item: Item, count: int, simulate: bool = false) -> int:
	if item == null or count < 1: return count;
	
	var remaining = count;
	
	# First, try to fill already existing stacks of this Item type.
	for slot_index in range(inventory.size()):
		var stack = inventory[slot_index];
		if stack == null or stack.item != item: continue;
		
		var remaining_from_add = stack.add(remaining, simulate);
		
		if not simulate and remaining_from_add != remaining:
			inventory_updated.emit(slot_index, stack, UpdateType.Add);
		
		remaining = remaining_from_add;
		if remaining <= 0: return 0;
	
	# If there are still items remaining, try empty slots.
	for slot_index in range(inventory.size()):
		if inventory[slot_index] != null: continue;
		
		inventory[slot_index] = ItemStack.new(item, 0);
		var remaining_from_add = inventory[slot_index].add(remaining, simulate);
		
		if not simulate and remaining_from_add != remaining:
			inventory_updated.emit(slot_index, inventory[slot_index], UpdateType.Add);
		
		remaining = remaining_from_add;
		if remaining <= 0: return 0;
	
	# Finally, return the amount of items that couldn't be added.
	return remaining;

# Returns the count of items that could NOT be removed.
func remove_item(item: Item, count: int, simulate: bool = false) -> int:
	if item == null or count < 1: return count;
	
	var remaining = count;
	
	for slot_index in range(inventory.size()):
		var stack = inventory[slot_index];
		if stack == null or stack.item != item: continue;
		
		var remaining_from_remove = stack.remove(remaining, simulate);
		
		if not simulate and remaining_from_remove != remaining:
			inventory_updated.emit(slot_index, stack, UpdateType.Remove);
			
			if stack.count == 0:
				inventory[slot_index] = null;
		
		remaining = remaining_from_remove;
		if remaining <= 0: return 0;
		
	return remaining;

# This slot returns an itemstack with the requested count, or less if the inventory doesn't contain so much.
func take_item(item: Item, count: int) -> ItemStack:
	var remaining = remove_item(item, count);
	
	if remaining == count:
		return null;
	else:
		return ItemStack.new(item, count-remaining);

func is_slot_within_bounds(slot: int) -> bool:
	return slot >= 0 and slot < inventory.size();

func add_item_to_slot(slot_index: int, item: Item, count: int, simulate: bool = false) -> int:
	if not is_slot_within_bounds(slot_index): return count;
	
	var stack = inventory[slot_index];
	
	if stack == null:
		stack = ItemStack.new(item, 0);
		if not simulate:
			inventory[slot_index] = stack;
	
	var remaining = stack.add(count, simulate);
	
	if not simulate:
		inventory_updated.emit(slot_index, stack, UpdateType.Add);
	
	return remaining;

func remove_item_from_slot(slot_index: int, count: int, simulate: bool = false) -> int:
	if not is_slot_within_bounds(slot_index): return count;
	
	var stack = inventory[slot_index];
	
	if stack == null: return count;
	
	var remaining = stack.remove(count, simulate);
	
	if not simulate:
		inventory_updated.emit(slot_index, stack, UpdateType.Remove);
	
	return remaining;

func get_item_count(item: Item) -> int:
	var total = 0;
	
	for slot in inventory:
		if slot == null or slot.item != item: continue;
		
		total += slot.count;
	
	return total;

func has_item(item: Item) -> bool:
	return get_item_count(item) > 0;

func get_stack_in_slot(slot_index: int) -> ItemStack:
	if not is_slot_within_bounds(slot_index): return null;
	
	return inventory[slot_index];
