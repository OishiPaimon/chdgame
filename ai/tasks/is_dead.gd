extends BTCondition

func _tick(_delta: float) -> Status:
	return SUCCESS if agent.status.health <= 0 else FAILURE 
