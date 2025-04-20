extends Control

@onready var resume: Button = $PanelContainer/VBoxContainer/Buttons/Resume
@onready var buttons: VBoxContainer = $PanelContainer/VBoxContainer/Buttons

func _ready() -> void:
	hide()
	visibility_changed.connect(func ():
		get_tree().paused=visible
	)
	
	for child in buttons.get_children():
		if child is Button:
			child.mouse_entered.connect(_on_Button_mouse_entered.bind(child))
	
func _on_Button_mouse_entered(button: Button):
	button.grab_focus()

func _on_resume_pressed() -> void:
	hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func show_pause() -> void:
	show()
	resume.grab_focus()

func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("puase"):
		hide()
		get_window().set_input_as_handled()
