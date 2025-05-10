extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var camera_2d: Camera2D = $player/Camera2D
@onready var ui_manager = $UIManager
@onready var monster_spawn_manager: MonsterSpawnManager = $MonsterSpawnManager

@export var spawn_config: SceneSpawnConfig

func  _ready() -> void:
	
	#获取tilemap大小 图块数量
	var used :=tile_map_layer.get_used_rect().grow(-1)
	#一个图块像素大小
	var tile_size :=tile_map_layer.tile_set.tile_size
	
	#相机
	camera_2d.limit_top=used.position.y*tile_size.y
	camera_2d.limit_bottom=used.end.y*tile_size.y
	camera_2d.limit_left=used.position.x*tile_size.x
	camera_2d.limit_right=used.end.x*tile_size.x
	
	#防止初始化抖动
	camera_2d.reset_smoothing()
	
	#初始人物状态
	$UIManager.init_status_panel($player/Status)
	
		# 初始化生成点组
	var spawn_groups = {
		"group1": $SpawnPoints/Group1.get_children(),
		"group2": $SpawnPoints/Group2.get_children()
	}
	monster_spawn_manager.init_spawn_groups(spawn_groups)
	
	# 设置生成配置
	if spawn_config:
		monster_spawn_manager.set_spawn_config(spawn_config.spawn_groups)
	
	# 生成怪物
	spawn_monsters()

func spawn_monsters() -> void:
	for group_name in monster_spawn_manager.spawn_point_groups:
		monster_spawn_manager.spawn_in_group(group_name)
	
#  调用暂停
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("puase"):
		$UIManager.show_pause()
