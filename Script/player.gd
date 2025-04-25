class_name Player
extends CharacterBody2D

# 定义角色的状态枚举
enum State
{
	IDLE,    # 静止状态
	RUNNING, # 跑动状态
	JUMP,    # 跳跃状态
	FALL     # 下落状态
}

# 定义在地面上的状态，用于判断起跳等逻辑
const GROUND_STATES := [State.IDLE, State.RUNNING]

# 绑定场景中的节点（按需加载）
@onready var sprite_2d: Sprite2D = $Graphics/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer                     # 土狼时间计时器
@onready var jump_request_timer: Timer = $JumpRequestTimer         # 跳跃请求缓冲计时器
@onready var status: Status = $Status                              # 状态控制器（自定义类）
#@onready var game_over_screen: Control = $CanvasLayer/GameOverScreen # 游戏结束界面
#@onready var pause_screen: Control = $CanvasLayer/PauseScreen      # 暂停界面

# 可导出变量：移动速度与跳跃速度
@export var move_speed: float = 50
@export var jump_speed: float = -500

# 获取默认重力设置
var default_gravity := ProjectSettings.get("physics/2d/default_gravity") as float
# 标记是否为状态切换后的第一帧
var is_first_tick := false

# 普通碰撞掩码（默认与图层0和5碰撞）
var normal_mask: int = (1 << 0) | (1 << 5)
# 一次性平台穿透掩码（只与图层0碰撞）
var pass_one_way_mask: int = (1 << 0)

# 初始化函数，节点首次进入场景树时调用
func _ready() -> void:
	pass

# 每帧更新物理行为，根据当前状态调用对应的逻辑
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.IDLE:
			move(default_gravity, delta)
		State.RUNNING:
			move(default_gravity, delta)
		State.JUMP:
			move(0.0 if is_first_tick else default_gravity, delta) # 第一帧不施加重力
		State.FALL:
			move(default_gravity, delta)
	is_first_tick = false

# 移动逻辑处理函数，处理左右移动、重力、平台穿透等
func move(gravity: float, delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	velocity.x = direction * move_speed
	velocity.y += gravity * delta
	
	if not is_zero_approx(direction):
		sprite_2d.flip_h = direction < 0  # 左右翻转角色朝向
	
	# 向下按键触发一次性穿透平台
	if Input.is_action_just_pressed("down"):
		collision_mask = pass_one_way_mask
		await get_tree().create_timer(0.1).timeout
		collision_mask = normal_mask
	
	move_and_slide()

# 输入事件处理函数（未被UI等捕获的输入）
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("puase"):
		get_tree().current_scene.get_node("UIManager").show_pause()
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	# 小跳：提前松开跳跃键时减小跳跃高度
	if event.is_action_released("jump") and velocity.y < jump_speed / 2:
		velocity.y = jump_speed / 2

# 状态判断函数，决定角色在下一帧的状态
func get_next_state(state: State) -> State:
	var can_jump := is_on_floor() or coyote_timer.time_left > 0
	var should_jump := can_jump and jump_request_timer.time_left > 0
	if should_jump:
		return State.JUMP
	
	var direction := Input.get_axis("left", "right")
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
			if velocity.y >= 0:
				return State.FALL
		State.FALL:
			if is_on_floor():
				return State.IDLE
	
	return state

# 状态切换时执行的动作处理（动画、速度重置、计时器控制）
func transition_state(from: State, to: State) -> void:
	if from not in GROUND_STATES and to in GROUND_STATES:
		coyote_timer.stop()
	
	match to:
		State.IDLE:
			animation_player.play("idle")
		State.RUNNING:
			animation_player.play("running")
		State.JUMP:
			animation_player.play("jump")
			velocity.y = jump_speed
			coyote_timer.stop()
			jump_request_timer.stop()
		State.FALL:
			animation_player.play("fall")
			if from in GROUND_STATES:
				coyote_timer.start()
	
	is_first_tick = true

# 角色死亡处理逻辑，显示游戏结束界面
func die() -> void:
	get_tree().current_scene.get_node("UIManager").show_game_over()

# 被敌人攻击的处理函数（未实现）
func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	pass  # 可替换为具体受击处理逻辑
