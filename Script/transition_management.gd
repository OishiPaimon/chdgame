extends CanvasLayer

@onready var animation:AnimationPlayer=$AnimationPlayer
@onready var player_stats: CharacterStatus = $PlayerStats
@onready var default_player_stats:=player_stats.to_dic()

func _ready() -> void:
	self.hide()

func change_scene(path,entry_pont:String)->void:
	var tree :=get_tree()
	self.show()
	self.set_layer(999)
	animation.play("Fade")
	await  animation.animation_finished
	
	tree.change_scene_to_file(path)
	await tree.tree_changed
	
	#更新玩家位置
	for node in tree.get_nodes_in_group("entry_points"):
		if node.name==entry_pont:
			tree.current_scene.update_player(node.global_position)
	
	animation.play_backwards("Fade")
	await  animation.animation_finished
	self.set_layer(-1)
	self.hide()

func new_game()->void:
	player_stats.from_dict(default_player_stats)
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	
