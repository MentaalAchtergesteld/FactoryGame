class_name BigBoi
extends BuildingScene

@onready var item_to_push: Item = ItemManager.get_item("iron_ore");
@onready var inventory: Inventory = $Inventory;
@onready var inventory_label: Label = $KeepUpright/InventoryLabel;
@onready var progress_label: Label = $KeepUpright/ProgressLabel;
@onready var timer: Timer = $Timer;
@onready var output_node: OutputNode = $OutputNode;

func _ready():
	update_inventory_label();
	inventory.add_item(item_to_push, 32);
	
	timer.time_left;

func _process(delta):
	update_progress_label();

func _on_timer_timeout():
	var amount_to_push = 1; 
	if inventory.get_item_count(item_to_push) >= amount_to_push:
		var remaining_amount = output_node.push_item(item_to_push, amount_to_push);
		inventory.remove_item(item_to_push, amount_to_push-remaining_amount);
	timer.start();


func _on_inventory_slot_updated(slot, stack):
	update_inventory_label();

func update_inventory_label():
	inventory_label.text = item_to_push.name + ": " + str(inventory.get_item_count(item_to_push));

func update_progress_label():
	progress_label.text = str(timer.time_left).substr(0, 4);
