extends BTCondition

func _tick(_delta: float) -> Status:
	return SUCCESS if agent.hitbox.has_overlapping_areas() else FAILURE 
