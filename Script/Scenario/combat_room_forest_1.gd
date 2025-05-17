extends BaseCombatRoom

# 森林场景特有的怪物组配置
func get_monster_groups() -> Dictionary:
	return {

	}

# 森林场景特有的生成规则
func get_spawn_rules() -> Dictionary:
	return {

	}

# 可以重写怪物选择逻辑
func select_monster_type(group_config: Dictionary) -> String:
	var monsters = group_config.get("monsters", [])
	var weights = group_config.get("weights", {})
	
	if monsters.is_empty():
		return ""
		
	var total_weight = 0.0
	for weight in weights.values():
		total_weight += weight
		
	var random_value = randf() * total_weight
	var current_weight = 0.0
	
	for monster_type in weights:
		current_weight += weights[monster_type]
		if random_value <= current_weight:
			return monster_type
	
	return monsters[0]  # 默认返回第一个怪物类型
