class_name OutputNode
extends Area2D

signal stack_pushed(item_stack: ItemStack);

func push_item_stack(item_stack: ItemStack) -> ItemStack:
	var cloned_stack = item_stack.clone();
	
	var overlapping_nodes = get_overlapping_areas();
	if overlapping_nodes.size() == 0: return cloned_stack;
	var input_node = overlapping_nodes[0] as InputNode;
	
	var leftover = input_node.push_item_stack(cloned_stack);
		
	cloned_stack.count -= leftover.count;
	stack_pushed.emit(cloned_stack);
	
	return leftover;
