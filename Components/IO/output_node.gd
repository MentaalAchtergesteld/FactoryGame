class_name OutputNode
extends Area2D

signal item_pushed(item: Item, amount: int);

# Returns the amount that could not be pushed.
func push_item(item: Item, amount: int) -> int:
	var overlapping_nodes = get_overlapping_areas();
	if overlapping_nodes.size() == 0: return amount;
	var input_node = overlapping_nodes[0] as InputNode;
	
	var remaining_amount = input_node.push_item(item, amount);
		
	item_pushed.emit(item, remaining_amount);
	
	return remaining_amount;
