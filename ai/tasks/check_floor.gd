extends BTAction

func _tick(_delta: float) -> Status:
	if  not agent.floor_checker.is_colliding():
		blackboard.set_var("need_turn", true)
		return FAILURE 
	return SUCCESS
