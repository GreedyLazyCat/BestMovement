extends RigidBody2D

@export var label: Label
@onready var area = $Area2D

var player: Player

var player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	area.body_entered.connect(self.player_entered)
	area.body_exited.connect(self.player_exited)

func player_entered(body):
	if body is Player:
		player_in_area = true
		label.visible = true
		player = body

func player_exited(body):
	if body is Player:
		player_in_area = false
		label.visible = false

func _process(delta):
	if Input.is_action_just_pressed("interact") and player_in_area:
		var new_item = Item.new()
		new_item.item_name = "HoundFirstLevelKey"
		new_item.item_display_name = "head"
		player.inventory_handler.add_item(new_item)
		queue_free()
func _physics_process(delta):
	var new_pos = global_position
	new_pos.x -= 5
	label.global_position = new_pos
	
