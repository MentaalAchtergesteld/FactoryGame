extends BuildingScene

@onready var output_node: OutputNode = $OutputNode;
@onready var inventory: Inventory = $Inventory;

func _process(delta):
	var stack = inventory.get_slot(0);
	if stack and stack.count > 0:
		var remaining_amount = output_node.push_item(stack.item, 1);
		inventory.remove_item(stack.item, 1-remaining_amount);
