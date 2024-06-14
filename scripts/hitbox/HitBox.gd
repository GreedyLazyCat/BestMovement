class_name HitBox
extends Area2D

enum DamageType {Impactful, Regular, SoulSpell}

@export var damage := 20
@export var direction := 1
@export var damage_type: DamageType = DamageType.Regular
@export var collision_shape: CollisionShape2D

signal hitted

func is_soul_spell() -> bool:
	return damage_type == DamageType.SoulSpell

func is_sword() -> bool:
	return damage_type == DamageType.Regular

func is_impactful():
	return damage_type == DamageType.Impactful

func _ready():
	assert(collision_shape, "Collision shape not referenced")

