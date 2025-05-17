extends BaseCombatRoom

# 森林场景特有的怪物组配置
func get_monster_groups() -> Dictionary:
	return {
		"Group1": {
			"monsters": ["pink", "owlet"],
			"weights": {
				"pink": 0.7,  # 70%概率生成粉色怪物
				"owlet": 0.3  # 30%概率生成猫头鹰怪物
			}
		},
		"Group2": {
			"monsters": ["owlet"],
			"weights": {
				"owlet": 1.0  # 空中只生成猫头鹰怪物
			}
		}
	}

# 森林场景特有的生成规则
func get_spawn_rules() -> Dictionary:
	return {
		"Group1": {
			"min_monsters": 2,
			"max_monsters": 4,
			"monster_weights": {
				"pink": 0.7,
				"owlet": 0.3
			}
		},
		"Group2": {
			"min_monsters": 1,
			"max_monsters": 2,
			"monster_weights": {
				"owlet": 1.0
			}
		}
	}

func  _ready() -> void:
	super()

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
