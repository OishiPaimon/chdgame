class_name MagicMissle

extends Node2D

enum Direction
{
	LEFT=-1,
	RIGHT=+1,
}
@export var spin_speed : float =300

@export var direction := Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():
			await ready
		self.scale.x=direction

func explosion()->void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
