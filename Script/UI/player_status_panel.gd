extends HBoxContainer

@export var status: CharacterStatus

@onready var health_bar: TextureProgressBar = $VBoxContainer/HealthBar
@onready var real_heath_bar: TextureProgressBar = $VBoxContainer/HealthBar/RealHeathBar
@onready var mana_bar: TextureProgressBar = $VBoxContainer/ManaBar
@onready var real_mana_bar: TextureProgressBar = $VBoxContainer/ManaBar/RealManaBar

func init():
	if status:
		status.health_changed.connect(update_health)
		status.mp_changed.connect(update_mp)
		
		update_health()
		update_mp()

func update_health():
	var percentage := status.health / float(status.max_health)
	health_bar.value = percentage
	real_heath_bar.value = percentage
	create_tween().tween_property(health_bar, "value", percentage, 0.3)

func update_mp():
	var percentage := status.mp / float(status.max_mp)
	mana_bar.value = percentage
	real_mana_bar.value = percentage
	create_tween().tween_property(mana_bar, "value", percentage, 0.3)
