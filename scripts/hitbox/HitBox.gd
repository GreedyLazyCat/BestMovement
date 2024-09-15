class_name HitBox
extends Area2D

enum DamageSource {Projectile, Melee}
enum DamageType {Blockable, Unblockable}

@export var damage := 20
@export var direction := 1
@export var damage_type: DamageType = DamageType.Blockable
@export var damage_source: DamageSource = DamageSource.Melee
@export var collision_shape: CollisionShape2D

signal hitted(blocked: bool)

func is_melee():
	return damage_source == DamageSource.Melee
	
func is_projectile():
	return damage_source == DamageSource.Projectile

func is_blockable():
	return damage_type == DamageType.Blockable
	
func is_unblockable():
	return damage_type == DamageType.Unblockable

func _ready():
	assert(collision_shape, "Collision shape not referenced")
