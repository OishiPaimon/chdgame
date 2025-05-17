class_name Teleporter
extends Interactable

@export_file("*.tscn") var path:String
@export var entry_point:String

func interact()->void:
	super()
	#场景转换
	TransitionManagement.change_scene(path,entry_point)
