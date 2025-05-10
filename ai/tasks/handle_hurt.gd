extends BTAction

func _tick(_delta: float) -> Status:
	agent.handle_hurt()
	agent.move_with_speed(0.0, _delta)
	return SUCCESS 
