extends CharacterBody2D

enum State
{
	IDLE,
	RUNNING,
	JUMP,
	FALL
}

const GROUND_STATES:=[State.IDLE,State.RUNNING]

@onready var sprite_2d: Sprite2D = $Graphics/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var pause_screen: Control = $CanvasLayer/PauseScreen
@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var status: Status = $Status
@onready var game_over_screen: Control = $CanvasLayer/GameOverScreen

@export var move_speed : float = 50
@export var jump_speed : float = -500

var default_gravity :=ProjectSettings.get("physics/2d/default_gravity") as float
var is_first_tick :=false
var normal_mask :int=(1<<0)|(1<<5)
var pass_one_way_mask :int =(1<<0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func tick_physics(state:State,delta: float) -> void:
	match state:
		State.IDLE:
			move(default_gravity,delta)
		
		State.RUNNING:
			move(default_gravity,delta)
		
		State.JUMP:
			move(0.0 if is_first_tick else default_gravity,delta)
		State.FALL:
			move(default_gravity,delta)
	
	is_first_tick=false
	

func move(gravity:float,delta:float)->void :	
	var direction := Input.get_axis("left","right")
	velocity.x=direction* move_speed
	velocity.y+=gravity*delta
	
	if not is_zero_approx(direction):
		sprite_2d.flip_h=direction<0
	
	if Input.is_action_just_pressed("down"):
		collision_mask=pass_one_way_mask
		await get_tree().create_timer(0.1).timeout
		collision_mask=normal_mask
	move_and_slide()

func  _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("puase"):
		pause_screen.show_pause()
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	#小跳	
	if event.is_action_released("jump") and velocity.y<jump_speed/2:
		velocity.y=jump_speed/2

func get_next_state(state:State)->State:
	var can_jump :=is_on_floor() or coyote_timer.time_left>0
	var should_jump :=can_jump and jump_request_timer.time_left>0
	if should_jump:
		return State.JUMP
	var direction := Input.get_axis("left","right")
	var is_still := is_zero_approx(direction) and is_zero_approx(velocity.x)
	
	match state:
		State.IDLE:
			if not is_on_floor():
				return State.FALL
			if not is_still:
				return State.RUNNING
		
		State.RUNNING:
			if not is_on_floor():
				return State.FALL
			if is_still:
				return State.IDLE
		
		State.JUMP:
			if velocity.y >=0:
				return State.FALL
		
		State.FALL:
			if is_on_floor():
				return State.IDLE
	
	return state

func transition_state(from:State,to:State)->void:
	
	if from not in GROUND_STATES and to in GROUND_STATES:
		coyote_timer.stop()
	
	match to:
		State.IDLE:
			animation_player.play("idle")
		
		State.RUNNING:
			animation_player.play("running")
		
		State.JUMP:
			animation_player.play("jump")
			velocity.y=jump_speed
			coyote_timer.stop()
			jump_request_timer.stop()
		
		State.FALL:
			animation_player.play("fall")
			if from in GROUND_STATES:
				coyote_timer.start()
	
	is_first_tick=true;

func die()->void:
	game_over_screen.show_game_over()

func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	pass # Replace with function body.
