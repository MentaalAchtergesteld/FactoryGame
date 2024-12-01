class_name TestBuilding
extends BuildingScene

@onready var item_to_check = ItemManager.get_item("iron_ore"); 
@onready var inventory: Inventory = $Inventory;
@onready var keep_upright: Node2D = $KeepUpright;
@onready var inventory_label: Label = $KeepUpright/InventoryLabel;
@onready var output_node: OutputNode = $OutputNode;

func _ready():
	keep_upright.rotation = -rotation;
	update_inventory_label();

func _process(delta):
	if inventory.get_item_count(item_to_check) > 0:
		var remaining_amount = output_node.push_item(item_to_check, 1);
		inventory.remove_item(item_to_check, 1-remaining_amount);

func _on_inventory_slot_updated(slot, stack):
	update_inventory_label();

func update_inventory_label():
	inventory_label.text = item_to_check.name + ": " + str(inventory.get_item_count(item_to_check));
