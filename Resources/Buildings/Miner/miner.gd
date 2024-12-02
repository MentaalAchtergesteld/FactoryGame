extends BuildingScene

@export var produced_ore: Item;
@export var production_speed: float = 2.0;
@export var production_amount: int = 1;

@export var miner_screen: Screen;

@onready var just_placed_timer: Timer = $JustPlacedTimer;
@onready var interactable: Interactable = $Interactable;
@onready var production_timer: Timer = $ProductionTimer;
@onready var inventory: Inventory = $Inventory;

@onready var output_node: OutputNode = $OutputNode;

func _ready():
	production_timer.wait_time = production_speed;
	production_timer.start();

var stack_to_push: ItemStack;

func _process(delta):
	if inventory.get_item_count(produced_ore) == 0: return;
	
	if stack_to_push == null:
		stack_to_push = inventory.take_item(produced_ore, 1);
	
	var remaining_amount = output_node.push_item(stack_to_push.item, stack_to_push.count);
	stack_to_push.count = remaining_amount;
	if stack_to_push.count <= 0:
		stack_to_push = null;

func _on_timer_timeout():
	inventory.add_item(produced_ore, production_amount);
	production_timer.start();

func _on_just_placed_timer_timeout():
	interactable.enabled = true;

func _on_interactable_interacted():
	print("Time Left: " + str(production_timer.time_left));
	inventory.debug();
