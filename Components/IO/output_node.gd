class_name OutputNode
extends Area2D

signal item_pushed(item: Item, amount: int);

func select_random_input_node() -> InputNode:
	var overlapping_areas = get_overlapping_areas();
	if overlapping_areas.size() == 0: return null;
	
	var possible_nodes = overlapping_areas.filter(func(area): return area is InputNode);
	if possible_nodes.size() == 0: return null;
	
	var random_index = randi_range(0, possible_nodes.size()-1);
	return possible_nodes[random_index] as InputNode;

# Returns the amount that could not be pushed.
func push(item: Item, amount: int) -> int:
	var input_node = select_random_input_node();
	if input_node == null: return amount;
	
	var remaining_amount = input_node.receive(item, amount);
		
	item_pushed.emit(item, remaining_amount);
	
	return remaining_amount;
