extends Button


func _ready() -> void:
	grab_focus()
	self.mouse_entered.connect(_on_Button_mouse_entered)
	
