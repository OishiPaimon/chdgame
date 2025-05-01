class_name CharacterStatus
extends Node

signal health_changed
signal mp_changed
signal exp_changed

@export var max_health:int=3
@export var max_mp:int=100
@export var max_exp:int=100

@onready var health: int = max_health:
	set(v):
		v=clampi(v,0,max_health)
		if health==v:
			return
		health=v
		health_changed.emit()

@onready var mp: int = max_mp:
	set(v):
		v=clampi(v,0,max_mp)
		if mp==v:
			return
		mp=v
		mp_changed.emit()

@onready var exp: int = 0:
	set(v):
		v=clampi(v,0,max_exp)
		if exp==v:
			return
		exp=v
		exp_changed.emit()

func add_exp(amount: int):
	exp += amount
	if exp >= max_exp:
		exp = 0
		# 升级逻辑
		
