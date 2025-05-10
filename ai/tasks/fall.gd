extends BTAction

func _tick(_delta: float) -> Status:
	if agent.is_on_floor() :
		return FAILURE 
	agent.move_with_speed(0, _delta)
	return SUCCESS 
