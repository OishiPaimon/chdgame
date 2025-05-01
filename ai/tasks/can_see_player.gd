@tool
extends BTCondition

func _tick(_delta: float) -> Status:
	if agent.can_see_player() or agent.calm_down_timer.get_time_left():
		if agent.can_see_player():
			agent.calm_down_timer.start()
		return SUCCESS 
	else: 
		return FAILURE 
