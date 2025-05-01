extends BTAction

func _tick(_delta: float) -> Status:
	agent.handle_hurt()
	return SUCCESS 
