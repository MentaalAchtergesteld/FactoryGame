class_name ItemStack
extends Resource

@export var item: Item;
@export var count: int = 0;

func _init(_item: Item, _count: int = 0):
	item = _item;
	count = _count;

func clone() -> ItemStack:
	return ItemStack.new(item, count);

func take(amount_to_take: int):
	count = max(0, count-amount_to_take);

func add(amount_to_add: int):
	count = min(item.max_stack_size, count+amount_to_add);

func set_count(new_count: int):
	count = new_count;
