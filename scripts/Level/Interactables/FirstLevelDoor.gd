extends StaticInteractable

@onready var collision_shape = $StaticBody2D/CollisionShape2D
@onready var label = $Label
@onready var color_rect = $ColorRect

var is_opened: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	label.visible = player_is_in_area and not is_opened

func _on_interacted():
	if player.inventory_handler.has_item("HoundFirstLevelKey"):
		player.inventory_handler.delete_item("HoundFirstLevelKey")
		color_rect.queue_free()
		collision_shape.set_deferred("disabled", true)
		is_opened = true
