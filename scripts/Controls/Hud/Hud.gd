class_name Hud
extends Control

@export var health_handler: HealthHandler
@export var dash_handler: DashBarHandler
@onready var hp_label = $HBoxContainer/HPLabel
@onready var dash_progress_bar = $DashProgressBar
@onready var stopwatch_label = $StopWatchLabel

var stopwatch: StopWatch

# Called when the node enters the scene tree for the first time.
func _ready():
	#assert(health_handler, "HealthHandler not connected")
	if health_handler:
		health_handler.health_changed.connect(self.on_health_changed)
		change_hp()

func connect_stopwatch(connecting: StopWatch):
	stopwatch = connecting

func disconnect_stopwatch():
	stopwatch = null

func connect_player(player: Player):
	player.health_handler.health_changed.connect(self.on_health_changed)
	health_handler = player.health_handler
	dash_handler = player.dash_handler
	change_hp()

func disconnect_player():
	health_handler = null
	dash_handler = null

func change_hp():
	if health_handler:
		var text = "HP: "
		for i in range(health_handler.health):
			text += "I"
		hp_label.text = text

func on_health_changed():
	change_hp()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dash_handler:
		var dash_progress = dash_handler.dash_value / (dash_handler.dash_max_value / 100)
		dash_progress_bar.value = dash_progress
	if stopwatch:
		stopwatch_label.text = stopwatch.get_formatted()
