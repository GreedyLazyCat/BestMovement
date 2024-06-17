class_name Hud
extends Control

@export var health_handler: HealthHandler
@export var dash_handler: DashBarHandler
@onready var hp_label = $HBoxContainer/HPLabel
@onready var dash_progress_bar = $DashProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(health_handler, "HealthHandler not connected")
	health_handler.health_changed.connect(self.on_health_changed)
	change_hp()
	
func change_hp():
	var text = "HP: "
	for i in range(health_handler.health):
		text += "I"
	hp_label.text = text

func on_health_changed():
	change_hp()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dash_progress = dash_handler.dash_value / (dash_handler.dash_max_value / 100)
	dash_progress_bar.value = dash_progress
