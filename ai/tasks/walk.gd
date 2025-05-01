extends BTAction

func _tick(_delta: float) -> Status:
	if agent.wall_checker.is_colliding() :
		agent.direction *= -1
	agent.move_with_speed(agent.max_spped/3, _delta)
	return SUCCESS 
