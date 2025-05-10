extends Enemy

const KNOCKBACK_AMOUT:=512.0

var pending_damage:Damage

@onready var wall_checker: RayCast2D = $Graphics/WallChecker
@onready var player_checker: RayCast2D = $Graphics/PlayerChecker
@onready var floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var calm_down_timer: Timer = $CalmDownTimer
@onready var attack_shape: CollisionShape2D = $Graphics/Hitbox/AttackShape
@onready var hitbox: Hitbox = $Graphics/Hitbox
@onready var bt_player: BTPlayer = $BTPlayer

# 检查是否可以看到玩家
func can_see_player() -> bool:
	if not player_checker.is_colliding():
		return false
	return player_checker.get_collider() is Player

# 移动逻辑
func move_with_speed(speed: float, delta: float) -> void:
	move(speed, delta)

# 处理受伤
func handle_hurt() -> void:
	if not pending_damage:
		return
		
	status.health -= pending_damage.amount
	
	# 击退
	var dir := pending_damage.source.global_position.direction_to(global_position)
	velocity = dir * KNOCKBACK_AMOUT
	
	# 被偷袭后转身
	if dir.x > 0:
		direction = Direction.LEFT
	else:
		direction = Direction.RIGHT
	
	pending_damage = null

func _on_hitbox_hit(hurtbox: Hurtbox) -> void:
	if hurtbox.owner is Player:
		bt_player.blackboard.set_var("should_attack", true)

# 信号处理
func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	pending_damage = Damage.new()
	pending_damage.amount = 1
	pending_damage.source = hitbox.owner
