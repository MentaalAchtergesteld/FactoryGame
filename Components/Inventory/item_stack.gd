class_name ItemStack
extends Resource

@export var item: Item;
@export var count: int = 0;

func _init(_item: Item, _count: int = 0):
	item = _item;
	count = _count;

func clone() -> ItemStack:
	return ItemStack.new(item, count);

func remove(amount: int, simulate: bool = false):
	var total_removed = min(count, amount);
	
	if not simulate: count -= total_removed;
	return amount - total_removed;

func add(amount: int, simulate: bool = false) -> int:
	var space_left = item.max_stack_size - count;
	var total_added = min(space_left, amount);
	
	if not simulate: count += total_added;
	return total_added - amount;

func is_full() -> bool:
	return count >= item.max_stack_size;
