class_name Inventory
extends Node

signal item_added(slot: int, stack: ItemStack);
signal item_removed(slot: int, stack: ItemStack);
signal slot_updated(slot: int, stack: ItemStack);

@export var inventory_size: int = 8:
	set(value):
		inventory_size = value;
		update_inventory_size();

var inventory: Array[ItemStack] = [];

func update_inventory_size():
	inventory.resize(inventory_size);

func _ready():
	update_inventory_size();

func debug():
	for i in range(inventory.size()):
		var stack = inventory[i];
		if stack == null:
			print("Slot " + str(i) + ": Empty");
		else:
			print("Slot " + str(i) + ": " + str(stack.count) + " " + stack.item.name);

func is_slot_within_bounds(slot: int) -> bool:
	var is_within_bounds = slot >= 0 and slot < inventory_size;
	if not is_within_bounds: print_debug("Tried accessing an inventory slot out of bounds: " + str(slot));
	return is_within_bounds

# Returns the amount that could not be added.
func add_item(item: Item, amount: int) -> int:
	if amount <= 0: return amount;
	var remaining_amount = amount;
	
	# Try to fill out any item stack with a matching item.
	for i in range(inventory.size()):
		var stack = inventory[i];
		if stack and stack.item == item and not stack.is_full():
			remaining_amount = add_to_slot(i, item, remaining_amount);
			item_added.emit(i, stack);
			
			if remaining_amount <= 0:
				return remaining_amount;
	
	# If not all items could be added, try adding to empty slots.
	for i in range(inventory.size()):
		if inventory[i] != null: continue;
		remaining_amount = add_to_slot(i, item, remaining_amount);
		item_added.emit(i, inventory[i]);
		
		if remaining_amount <= 0:
			return remaining_amount;
	
	return remaining_amount;

# Returns the amount that could not be removed.
func remove_item(item: Item, amount: int) -> int:
	if amount <= 0: return amount;
	var remaining_amount = amount;
	
	for i in range(inventory.size()):
		var stack = inventory[i];
		if stack and stack.item == item:
			remaining_amount = remove_from_slot(i, remaining_amount);
			item_removed.emit(i, stack);
			
			if stack.count <= 0:
				inventory[i] = null;
			
			if remaining_amount <= 0:
				return remaining_amount;
	
	return remaining_amount;

func take_item(item: Item, amount: int) -> ItemStack:
	if amount <= 0: return ItemStack.new(item, 0);
	var remaining_amount = remove_item(item, amount);
	if remaining_amount <= 0: return null;
	return ItemStack.new(item, amount-remaining_amount);

# Returns the amount that could not be added.
func add_to_slot(slot: int, item: Item, amount: int) -> int:
	if amount <= 0: return amount;
	if not is_slot_within_bounds(slot): return amount;
	
	var stack = inventory[slot];
	if stack == null:
		inventory[slot] = ItemStack.new(item);
		stack = inventory[slot];
	
	if stack.item != item or stack.is_full(): return amount;
	
	var remaining_amount = stack.add(amount);
	
	slot_updated.emit(slot, stack);
	return remaining_amount;

# Returns the amount that could not be removed.
func remove_from_slot(slot: int, amount: int) -> int:
	if amount <= 0: return amount;
	if not is_slot_within_bounds(slot): return 0
	
	var stack = inventory[slot];
	if stack == null: return amount;
	
	var remaining_amount = stack.remove(amount);
	
	slot_updated.emit(slot, stack);
	return remaining_amount;

func set_slot(slot: int, stack: ItemStack) -> bool:
	if not is_slot_within_bounds(slot): return false;
	
	inventory[slot] = stack;
	
	slot_updated.emit(slot, stack);
	return true;

func get_slot(slot: int) -> ItemStack:
	if not is_slot_within_bounds(slot): return null;
	return inventory[slot];

func get_item_count(item: Item) -> int:
	var total_count = 0;
	for i in range(inventory.size()):
		var stack = inventory[i];
		if stack and stack.item == item:
			total_count += stack.count;
	return total_count;
