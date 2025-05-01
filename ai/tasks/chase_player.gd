extends BTAction

func _tick(_delta: float) -> Status:
	if agent.wall_checker.is_colliding() or not agent.floor_checker.is_colliding():
		agent.direction *= -1
	agent.move_with_speed(agent.max_spped, _delta)
	return SUCCESS 
