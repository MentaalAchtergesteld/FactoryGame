class_name Belt
extends BuildingScene

@export var max_stack_count: int = 1;
@export var belt_speed: float = 1;

@onready var item_move_timer: Timer = $ItemMoveTimer;

var belt_network: BeltNetwork;

var queue_item_move: bool = false;
var current_items: Array[ItemStack] = [];

func _ready():
	current_items.resize(max_stack_count);

func _process(delta):
	if queue_item_move and item_move_timer.is_stopped():
		item_move_timer.start(belt_speed);

func add_item(item: Item, count: int) -> int:
	if current_items[max_stack_count-1] != null: return count;
	queue_item_move = true;
	current_items.append(ItemStack.new(item, count));
	return 0;

func _on_item_move_timer_timeout():
	if current_items[0] == null: return;
	var remaining = belt_network.push_to_next_belt(current_items[0]);
	
	current_items[0].count = remaining;
	if current_items[0].count <= 0:
		current_items.remove_at(0);
		current_items.append(null);
