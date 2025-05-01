extends BTCondition

func _tick(_delta: float) -> Status:
	return SUCCESS if agent.pending_damage != null else FAILURE 
