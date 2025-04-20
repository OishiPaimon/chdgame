extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var move_speed : float = 50
@export var jump_speed : float = -500
@onready var pause_screen: Control = $CanvasLayer/PauseScreen

var gravity :=ProjectSettings.get("physics/2d/default_gravity") as float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#velocity = Vector2(50,0)
	pass

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left","right")
	velocity.x=direction* move_speed
	
	velocity.y+=gravity*delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y=jump_speed
	
	if is_on_floor():
		if is_zero_approx(direction):
			animation_player.play("idle")
		else:
			animation_player.play("running")
	else:
		animation_player.play("jump")
	
	
	if not is_zero_approx(direction):
		sprite_2d.flip_h=direction<0
	
	move_and_slide()

func  _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("puase"):
		pause_screen.show_pause()
