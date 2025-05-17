class_name BaseCombatRoom

extends Node2D


# 基础节点引用
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var camera_2d: Camera2D = $player/Camera2D
@onready var monster_spawn_manager: MonsterSpawnManager = $MonsterSpawnManager
@onready var player: Player = $player
@onready var spawn_points: Node2D = $SpawnPoints

# 可配置属性
@export var player_spawn_point: Node2D
@export var exit_gate: Node2D

# 怪物生成相关配置
var monster_groups: Dictionary = {}
var spawn_rules: Dictionary = {}

# 初始化函数
func _ready() -> void:
	setup_camera_limits()
	setup_monster_spawning()
	spawn_monsters()

# 设置相机限制
func setup_camera_limits() -> void:
	var used := tile_map_layer.get_used_rect().grow(-1)
	var tile_size := tile_map_layer.tile_set.tile_size
	
	camera_2d.limit_top = used.position.y * tile_size.y
	camera_2d.limit_bottom = used.end.y * tile_size.y
	camera_2d.limit_left = used.position.x * tile_size.x
	camera_2d.limit_right = used.end.x * tile_size.x
	
	camera_2d.reset_smoothing()

# 设置怪物生成系统
func setup_monster_spawning() -> void:
	# 获取子类定义的怪物组配置
	monster_groups = get_monster_groups()
	# 获取子类定义的生成规则
	spawn_rules = get_spawn_rules()
	
	# 初始化生成点组
	var spawn_groups = get_spawn_groups()
	monster_spawn_manager.init_spawn_groups(spawn_groups)
	
	# 设置生成配置
	monster_spawn_manager.set_spawn_config(spawn_rules)

# 获取生成点组
func get_spawn_groups() -> Dictionary:
	var groups = {}
	if spawn_points==null :
		return groups
	for group in spawn_points.get_children():
		groups[group.name] = group.get_children()
	return groups

# 生成怪物
func spawn_monsters() -> void:
	for group_name in monster_spawn_manager.spawn_point_groups:
		var group_config = spawn_rules.get(group_name, {})
		if not group_config.is_empty():
			monster_spawn_manager.spawn_in_group(group_name)

# 虚函数：获取怪物组配置
func get_monster_groups() -> Dictionary:
	# 子类需要重写此函数来定义自己的怪物组
	return {}

# 虚函数：获取生成规则
func get_spawn_rules() -> Dictionary:
	# 子类需要重写此函数来定义自己的生成规则
	return {}

# 虚函数：选择怪物类型
func select_monster_type(group_config: Dictionary) -> String:
	# 子类可以重写此函数来自定义怪物选择逻辑
	return ""

# 更新玩家位置
func update_player(pos: Vector2) -> void:
	player.global_position = pos
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()
