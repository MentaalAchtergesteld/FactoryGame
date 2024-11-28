class_name BuildingScene
extends StaticBody2D


func _on_input_node_stack_pushed(item_stack):
	var item = $Inventory.get_slot(0);
	#if item == null: return;
	$Label.text = str($Inventory.inventory)
