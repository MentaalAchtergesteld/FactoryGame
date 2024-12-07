extends BuildingScene

@export var max_output: int = 1;

@onready var output_node: OutputNode = $OutputNode;
@onready var inventory: Inventory = $Inventory;

func _process(delta):
	var stack = inventory.get_stack_in_slot(0);
	if stack == null: return;
	
	var amount_to_push = min(stack.count, max_output);
	if amount_to_push <= 0: return;
	
	var remaining_amount_to_push = output_node.push(stack.item, amount_to_push);
	inventory.remove_item(stack.item, amount_to_push-remaining_amount_to_push);
