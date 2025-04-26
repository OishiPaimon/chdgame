extends Control

# 发出重启请求的信号，由 UIManager 或 GameManager 响应处理
signal restart_requested

# 获取动画播放器节点
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# 初始化：默认隐藏并关闭输入处理
func _ready() -> void:
	hide()
	set_process_input(false)

# 处理输入事件（如按键、鼠标点击、手柄按钮）
func _input(event: InputEvent) -> void:
	get_window().set_input_as_handled()  # 阻止事件向下传播
	
	# 如果动画播放中，不接受操作
	if animation_player.is_playing():
		return
	
	# 判断是否是有效的“确认”类输入事件
	if (
		event is InputEventKey or 
		event is InputEventMouseButton or 
		event is InputEventJoypadButton
	):
		if event.is_pressed() and not event.is_echo():
			# 发出重启请求信号（不直接处理跳转）
			emit_signal("restart_requested")

# 外部调用此方法以展示 Game Over UI
func show_game_over() -> void:
	show()
	set_process_input(true)
	animation_player.play("enter")
