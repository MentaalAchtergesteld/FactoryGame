class_name BigBoi
extends BuildingScene

func _on_timer_timeout():
	var item = ItemManager.get_item("iron_ore");
	if item != null:
		var stack = ItemStack.new(item, 1);
		
		var leftover = $OutputNode.push_item_stack(stack);
	
	$Timer.start();
