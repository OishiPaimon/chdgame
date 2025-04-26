extends Enemy


enum State
{
	IDLE,
	WALK,
	RUN,
	ATTACK_1,
	ATTACK_2,
	HURT,
	DYING,
}

const KNOCKBACK_AMOUT:=512.0

var pending_damage:Damage
var should_attack :=false

@onready var wall_checker: RayCast2D = $Graphics/WallChecker
@onready var player_checker: RayCast2D = $Graphics/PlayerChecker
@onready var floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var calm_down_timer: Timer = $CalmDownTimer
@onready var attack_shape: CollisionShape2D = $Graphics/Hitbox/AttackShape
@onready var hitbox: Hitbox = $Graphics/Hitbox


func can_see_player()->bool:
	if not player_checker.is_colliding():
		return false;
	return player_checker.get_collider() is Player

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.IDLE,State.HURT,State.DYING:
			move(0.0,delta)
		
		State.WALK:
			move(max_spped/3,delta)
		
		State.RUN:
			if wall_checker.is_colliding() or not floor_checker.is_colliding():
				direction*=-1
			move(max_spped,delta)
			if player_checker.is_colliding():
				calm_down_timer.start()

func get_next_state(state:State)->State:
	
	if status.health==0:
		return State.DYING
	
	if pending_damage:
		return State.HURT
	
	if should_attack:
		return State.ATTACK_1
	
	match state:
		State.IDLE:
			#遇见玩家开始跑
			if can_see_player():
				return State.RUN
			#站立时间超过2s开始走
			if state_machine.state_time>2:
				return State.WALK
		
		State.WALK:
			#遇见玩家开始跑
			if can_see_player():
				return State.RUN
			#撞墙了或者前面没有地板了开始站立（后续可以增加跳跃和滑墙）
			if wall_checker.is_colliding() or not floor_checker.is_colliding():
				return State.IDLE
		
		State.RUN:
			#当玩家离开视野一段时间后开走
			if not can_see_player() and calm_down_timer.is_stopped():
				return State.WALK
				
		State.ATTACK_1:
			if not animation_player.is_playing():
				#判断是否还在攻击范围内（很蠢要改）
				if hitbox.has_overlapping_areas():
					return State.ATTACK_1
				else:
					return State.RUN
		
		State.HURT:
			if not animation_player.is_playing():
				return State.RUN
		
	return state

# 状态切换时执行的动作处理（动画、速度重置、计时器控制）
func transition_state(from: State, to: State) -> void:
	match to:
		State.IDLE:
			animation_player.play("idle")
			#如果前面是墙就转身
			if wall_checker.is_colliding():
				direction*=-1
		
		State.WALK:
			animation_player.play("walk")
			#如果前面是悬崖就转身
			if not floor_checker.is_colliding():
				direction*=-1
				#防止转身后站立一下
				floor_checker.force_raycast_update()
		
		State.RUN:
			animation_player.play("run")
		
		State.ATTACK_1:
			animation_player.play("attack1")
			should_attack=false
		
		State.HURT:
			animation_player.play("hit")
			
			status.health-=pending_damage.amount
			
			#击退
			var dir :=pending_damage.source.global_position.direction_to(global_position)
			velocity=dir*KNOCKBACK_AMOUT
			
			#被偷袭后转身
			if dir.x>0:
				direction=Direction.LEFT
			else:
				direction=Direction.RIGHT
			
			pending_damage=null
		
		State.DYING:
			animation_player.play("die")

func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	#多个伤害来源需要修改为数组或者混合到一起
	pending_damage=Damage.new()
	pending_damage.amount=1
	pending_damage.source=hitbox.owner


func _on_hitbox_hit(hurtbox: Hurtbox) -> void:
	if hurtbox.owner is Player:
		should_attack=true
