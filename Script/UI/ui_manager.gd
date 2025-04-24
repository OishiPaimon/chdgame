extends CanvasLayer

# 引用各个 UI 子界面
@onready var game_over_screen = $GameOverScreen
@onready var pause_screen = $PauseScreen
@onready var status_panel = $StatusPanel

# 初始化：连接信号
func _ready():
	# 连接 Game Over UI 的“重启请求”信号
	game_over_screen.restart_requested.connect(_on_restart_requested)

# 外部调用：显示 Game Over UI，并暂停游戏
func show_game_over():
	game_over_screen.show_game_over()
	get_tree().paused = true

# 信号回调：收到 Game Over 界面请求“重新开始游戏”
func _on_restart_requested():
	get_tree().paused = false  # 恢复游戏运行
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")  # 重新载入游戏场景

# 暂停界面
func show_pause():
	pause_screen.show_pause()

# 数值化血条
func init_status_panel(status_data: Status):
	$StatusPanel.status = status_data
	$StatusPanel.init()
