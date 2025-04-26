class_name Fireball
extends MagicMissle

enum State
{
	LAUNCH,
	IMPACT,
}
var should_imapct :=false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.LAUNCH:
			position.x+=direction*spin_speed*delta


func get_next_state(state:State)->State:
	
	match state:
		State.LAUNCH:
			#爆炸
			if should_imapct:
				return State.IMPACT
		
	return state

# 状态切换时执行的动作处理（动画、速度重置、计时器控制）
func transition_state(from: State, to: State) -> void:
	match to:
		State.LAUNCH:
			should_imapct=false
			animation_player.play("spin")
		
		State.IMPACT:
			animation_player.play("explosion")

func _on_hitbox_hit(hurtbox: Hurtbox) -> void:
		should_imapct=true
