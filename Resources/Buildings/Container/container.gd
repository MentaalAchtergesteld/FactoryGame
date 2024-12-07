extends BuildingScene

@export var max_output: int = 1;

@onready var interactable: Interactable = $Interactable;
@onready var output_node: OutputNode = $OutputNode;
@onready var inventory: Inventory = $Inventory;
@onready var inventory_label: Label = $KeepUpright/InventoryLabel;

func _process(delta):
	for index in inventory.inventory.size():
		var stack = inventory.get_stack_in_slot(0);
		if stack == null: continue;
		
		var amount_to_push = min(stack.count, max_output);
		if amount_to_push <= 0: continue;
		
		var remaining_amount_to_push = output_node.push(stack.item, amount_to_push);
		inventory.remove_item(stack.item, amount_to_push-remaining_amount_to_push);
		
		break;

func _on_interactable_interacted():
	print(inventory.debug());

func _on_just_placedtimer_timeout():
	interactable.enabled = true;


func _on_inventory_inventory_updated(slot_index, item_stack, update_type):
	inventory_label.text = inventory.debug();
