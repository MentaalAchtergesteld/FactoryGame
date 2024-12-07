extends BuildingScene

@export var produced_ore: Item;
@export var production_speed: float = 2.0;
@export var production_amount: int = 1;

@export var max_output: int = 1;

@export var miner_screen: Screen;

@onready var interactable: Interactable = $Interactable;
@onready var production_timer: Timer = $ProductionTimer;
@onready var inventory: Inventory = $Inventory;

@onready var output_node: OutputNode = $OutputNode;

func _ready():
	production_timer.wait_time = production_speed;
	production_timer.start();

var stack_to_push: ItemStack;

func _process(delta):
	var amount_to_push = min(inventory.get_item_count(produced_ore), max_output);
	if amount_to_push <= 0: return;
	
	var remaining_amount_to_push = output_node.push(produced_ore, amount_to_push);
	inventory.remove_item(produced_ore, amount_to_push-remaining_amount_to_push);

func _on_timer_timeout():
	inventory.add_item(produced_ore, production_amount);
	production_timer.start();

func _on_just_placed_timer_timeout():
	interactable.enabled = true;

func _on_interactable_interacted():
	print("Time Left: " + str(production_timer.time_left));
	print(inventory.debug());
