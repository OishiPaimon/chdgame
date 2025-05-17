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
var spawn_config: Dictionary = {}

# 初始化生成点组
func init_spawn_groups(groups: Dictionary) -> void:
	spawn_point_groups = groups

# 设置生成配置
func set_spawn_config(config: Dictionary) -> void:
	spawn_config = config

# 在指定组中生成怪物
func spawn_in_group(group_name: String, specific_monster_type: String = "") -> void:
	if not spawn_point_groups.has(group_name):
		push_error("Spawn group not found: " + group_name)
		return
		
	var spawn_points = spawn_point_groups[group_name]
	if spawn_points.is_empty():
		push_error("No spawn points found in group: " + group_name)
		return
		
	var config = spawn_config.get(group_name, {})
	if config.is_empty():
		push_error("No spawn config found for group: " + group_name)
		return

	# 随机决定生成数量
	var min_monsters = config.get("min_monsters", 1)
	var max_monsters = config.get("max_monsters", 3)
	
	if min_monsters > max_monsters:
		push_error("Invalid monster count range for group: " + group_name)
		return
		
	var spawn_count = randi_range(min_monsters, max_monsters)
	
	# 生成怪物
	for i in range(spawn_count):
		var monster_type = specific_monster_type if specific_monster_type != "" else _get_random_monster_type(group_name)
		if monster_type.is_empty():
			push_error("Failed to select monster type for group: " + group_name)
			continue
			
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		
		if monster_scenes.has(monster_type):
			var monster = monster_scenes[monster_type].instantiate()
			spawn_point.add_child(monster)
			monster.global_position = spawn_point.global_position
		else:
			push_error("Monster type not found: " + monster_type)

# 获取随机怪物类型
func _get_random_monster_type(group_name: String) -> String:
	var config = spawn_config.get(group_name, {})
	var monster_weights = config.get("monster_weights", {})
	
	if monster_weights.is_empty():
		push_error("No monster weights found for group: " + group_name)
		return ""
		
	var total_weight = 0.0
	for weight in monster_weights.values():
		total_weight += weight
		
	if total_weight <= 0:
		push_error("Invalid monster weights for group: " + group_name)
		return ""
		
	var random_value = randf() * total_weight
	var current_weight = 0.0
	
	for monster_type in monster_weights:
		current_weight += monster_weights[monster_type]
		if random_value <= current_weight:
			return monster_type
	
	# 如果由于浮点数精度问题没有选中任何怪物，返回第一个
	return monster_weights.keys()[0] if not monster_weights.is_empty() else ""

# 注册新的怪物类型
func register_monster_type(type_name: String, scene_path: String) -> void:
	monster_scenes[type_name] = load(scene_path)

# 获取当前组的所有怪物
func get_monsters_in_group(group_name: String) -> Array:
	var monsters = []
	if spawn_point_groups.has(group_name):
		for spawn_point in spawn_point_groups[group_name]:
			for child in spawn_point.get_children():
				if child is Node2D:  # 假设所有怪物都是 Node2D
					monsters.append(child)
	return monsters

# 检查组是否达到最大怪物数量
func is_group_at_max(group_name: String) -> bool:
	var config = spawn_config.get(group_name, {})
	var max_monsters = config.get("max_monsters", 3)
	return get_monsters_in_group(group_name).size() >= max_monsters

# 清理指定组的所有怪物
func clear_group(group_name: String) -> void:
	if spawn_point_groups.has(group_name):
		for spawn_point in spawn_point_groups[group_name]:
			for child in spawn_point.get_children():
				if child is Node2D:
					child.queue_free()
