class_name MonsterSpawnManager
extends Node

# 怪物预制体配置
var monster_scenes: Dictionary = {
	"owlet": preload("res://Scenes/Characters/Enemies/owlet_monster.tscn"),
	"pink": preload("res://Scenes/Characters/Enemies/pink_monster.tscn")
}

# 怪物生成点组
var spawn_point_groups: Dictionary = {}

# 怪物生成配置
var spawn_config: Dictionary = {
	"min_monsters": 2,  # 最少生成数量
	"max_monsters": 5,  # 最多生成数量
	"monster_weights": {  # 怪物生成权重
		"owlet": 0.6,
		"pink": 0.4
	}
}

# 初始化生成点组
func init_spawn_groups(groups: Dictionary) -> void:
	spawn_point_groups = groups

# 设置生成配置
func set_spawn_config(config: Dictionary) -> void:
	spawn_config = config

# 在指定组中生成怪物
func spawn_in_group(group_name: String) -> void:
	if not spawn_point_groups.has(group_name):
		push_error("Spawn group not found: " + group_name)
		return
		
	var spawn_points = spawn_point_groups[group_name]
	if spawn_points.is_empty():
		return
		
	var config=spawn_config[group_name]
	# 随机决定生成数量
	var spawn_count = randi_range(
		config.min_monsters,
		config.max_monsters
	)
	
	# 生成怪物
	for i in range(spawn_count):
		var monster_type = _get_random_monster_type(group_name)
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		
		var monster = monster_scenes[monster_type].instantiate()
		spawn_point.add_child(monster)
		monster.global_position = spawn_point.global_position

# 获取随机怪物类型
func _get_random_monster_type(group_name: String) -> String:
	var config=spawn_config[group_name]
	var total_weight = 0.0
	for weight in config.monster_weights.values():
		total_weight += weight
		
	var random_value = randf() * total_weight
	var current_weight = 0.0
	
	for monster_type in config.monster_weights:
		current_weight += config.monster_weights[monster_type]
		if random_value <= current_weight:
			return monster_type
	
	return config.monster_weights.keys()[0]  # 默认返回第一个

# 注册新的怪物类型
func register_monster_type(type_name: String, scene_path: String) -> void:
	monster_scenes[type_name] = load(scene_path) 
