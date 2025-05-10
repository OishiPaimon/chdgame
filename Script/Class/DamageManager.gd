class_name DamageManager
extends Node

signal damage_received(damages: Array[Damage])

var pending_damages: Array[Damage] = []

func add_damage(damage: Damage) -> void:
	pending_damages.append(damage)
	damage_received.emit(pending_damages)

func get_all_damages() -> Array[Damage]:
	var damages = pending_damages.duplicate()
	pending_damages.clear()
	return damages

func clear_damages() -> void:
	pending_damages.clear() 
