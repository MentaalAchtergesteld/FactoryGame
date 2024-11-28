class_name Inventory
extends Node

@export var inventory_size: int = 8:
	set(value):
		inventory_size = value;
		inventory.resize(inventory_size);

var inventory: Array[ItemStack] = [];

func _ready():
	inventory.resize(inventory_size);

func add_item(item_stack: ItemStack) -> ItemStack:
	var cloned_stack = item_stack.clone();
	if item_stack.count <= 0: return cloned_stack;
	
	var same_item_stacks = inventory.filter(func(slot_stack: ItemStack):
		if slot_stack == null: return false;
		return slot_stack.item.id == item_stack.item.id
	);
	
	for slot_stack in same_item_stacks:
		var space_left_in_stack = slot_stack.item.max_stack_size - slot_stack.count;
		var max_to_add = min(space_left_in_stack, cloned_stack.count);
		if max_to_add <= 0: continue;
		
		slot_stack.count += max_to_add;
		cloned_stack.count -= max_to_add;
		if cloned_stack.count <= 0:
			return cloned_stack;
	
	var empty_slots = inventory.filter(func(slot): return slot == null);
	
	for slot in empty_slots:
		var max_to_add = min(cloned_stack.count, cloned_stack.item.max_stack_size);
		if max_to_add <= 0: break;
		
		var new_stack = cloned_stack.clone();
		new_stack.count = max_to_add;
		slot = new_stack;
		cloned_stack.count -= max_to_add;
		
		if cloned_stack.count <= 0:
			return cloned_stack;
	
	
	return cloned_stack;

func take_from_slot(slot: int) -> ItemStack:
	if slot < 0 or slot > inventory_size-1:
		return null;
	var item_stack = inventory[slot].clone();
	inventory[slot] = null;
	return item_stack;

func set_slot(slot: int, item_stack: ItemStack) -> bool:
	if slot < 0 or slot > inventory_size-1:
		return false;
	inventory[slot] = item_stack.clone();
	return true;

func get_slot(slot: int) -> ItemStack:
	if slot < 0 or slot > inventory_size-1: return null;
	return inventory[slot];
