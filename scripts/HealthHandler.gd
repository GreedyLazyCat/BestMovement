class_name HealthHandler
extends Node

@export var max_health: int = 100
var health: int

signal dead
signal health_changed

func _ready():
	health = max_health

func deal_damage(damage: int):
	health -= damage
	if health <= 0:
		health = 0
		dead.emit()
	health_changed.emit()

func heal(amount: int):
	health += amount
	if health > max_health:
		health = max_health
