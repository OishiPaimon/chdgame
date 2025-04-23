extends HBoxContainer

@export var status:Status

@onready var health_bar: TextureProgressBar = $VBoxContainer/HealthBar
@onready var real_heath_bar: TextureProgressBar = $VBoxContainer/HealthBar/RealHeathBar

func _ready() -> void:
	status.health_changed.connect(update_health)
	update_health()

func  update_health()->void:
	var percentage :=status.health/float(status.max_health)
	health_bar.value=percentage
	
	real_heath_bar.value=percentage
	create_tween().tween_property(health_bar,"value",percentage,0.3)
