extends CharacterBody2D

@export var owlet_speed : float = -0
@export var rush_speed : float = -200  # 加速速度
var player_in_range := false

func _ready() -> void:
	$DetectionArea.body_entered.connect(_on_DetectionArea_body_entered)
	$DetectionArea.body_exited.connect(_on_DetectionArea_body_exited)

func _on_DetectionArea_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_DetectionArea_body_exited(body):
	if body.name == "player":
		player_in_range = false

func _physics_process(delta: float) -> void:
	if player_in_range:
		velocity.x = rush_speed
	else:
		velocity.x = owlet_speed

	move_and_slide()
	$Graphics/AnimatedSprite2D.flip_h = velocity.x < 0
