extends Node2D

func _ready() -> void:
	$CenterContainer/SettingsMenu/fullscreen.button_pressed=true if DisplayServer.window_get_mode()==DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else false
	$CenterContainer/SettingsMenu/mainvolslider.value=db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$CenterContainer/SettingsMenu/musicvolslider.value=db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$CenterContainer/SettingsMenu/sfxvolslider.value=db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func _on_play_pressed() -> void:
	var scene="res://Scenes/Scenario/world_1.tscn"
	TransitionManagement.change_scene(scene);


func _on_settings_pressed() -> void:
	$CenterContainer/MainButtons.visible=false
	$CenterContainer/SettingsMenu.visible=true
	$CenterContainer/SettingsMenu/back.grab_focus()

func _on_credits_pressed() -> void:
	$CenterContainer/MainButtons.visible=false
	$CenterContainer/CreditsMenu.visible=true
	$CenterContainer/CreditsMenu/back.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$CenterContainer/MainButtons.visible=true
	if $CenterContainer/SettingsMenu.visible:
		$CenterContainer/SettingsMenu.visible=false
		$CenterContainer/MainButtons/settings.grab_focus()
		
	if $CenterContainer/CreditsMenu.visible:
		$CenterContainer/CreditsMenu.visible=false
		$CenterContainer/MainButtons/credits.grab_focus()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_mainvolslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"),value)


func _on_musicvolslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),value)


func _on_sfxvolslider_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"),value)
