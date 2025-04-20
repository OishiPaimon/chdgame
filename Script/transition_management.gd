extends CanvasLayer

@onready var animation:AnimationPlayer=$AnimationPlayer

func _ready() -> void:
	self.hide()

func change_scene(path):
	self.show()
	self.set_layer(999)
	animation.play("Fade")
	await  animation.animation_finished
	get_tree().change_scene_to_file(path)
	animation.play_backwards("Fade")
	await  animation.animation_finished
	self.set_layer(-1)
	self.hide()
