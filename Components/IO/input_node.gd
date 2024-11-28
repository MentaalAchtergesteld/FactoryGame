class_name InputNode
extends Area2D

signal stack_pushed(item_stack: ItemStack);

@export var inventory: Inventory;

func push_item_stack(item_stack: ItemStack) -> ItemStack:
	var cloned_stack = item_stack.clone();
	if inventory == null: return cloned_stack;
	
	var leftover = inventory.add_item(cloned_stack);
	
	cloned_stack.count -= leftover.count;
	stack_pushed.emit(cloned_stack);
	
	return leftover;
