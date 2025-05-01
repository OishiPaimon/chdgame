extends BTAction

func _tick(_delta: float) -> Status:
	if blackboard.get_var("need_turn"):
		agent.direction *= -1
		agent.floor_checker.force_raycast_update()
		blackboard.set_var("need_turn", false)
	return SUCCESS 
