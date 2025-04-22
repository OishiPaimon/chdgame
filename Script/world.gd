extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var camera_2d: Camera2D = $player/Camera2D
var game_over_ui = preload("res://Scenes/GameOver.tscn").instantiate()

func  _ready() -> void:
	
	#获取tilemap大小 图块数量
	var used :=tile_map_layer.get_used_rect().grow(-1)
	#一个图块像素大小
	var tile_size :=tile_map_layer.tile_set.tile_size
	
	#set camera limit
	camera_2d.limit_top=used.position.y*tile_size.y
	camera_2d.limit_bottom=used.end.y*tile_size.y
	camera_2d.limit_left=used.position.x*tile_size.x
	camera_2d.limit_right=used.end.x*tile_size.x
	
	#防止初始化抖动
	camera_2d.reset_smoothing()

func show_game_over():
	add_child(game_over_ui)
	get_tree().paused = true  # 可选：暂停游戏
