class_name LaunchFireball

extends Ability

@export var scene:PackedScene
@export var instancing_offset:Vector2

func use(user:Node2D)->bool:
	var instance:Fireball=scene.instantiate()
	user.get_parent().add_child(instance)
	instance.global_position=instancing_offset;
	return true
