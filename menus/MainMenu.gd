extends Control

onready var camera_2d: Camera2D = $Camera2D
onready var level_selector_button: Button = $ButtonContainer/LevelSelectorButton
onready var glossary_button: Button = $ButtonContainer/GlossaryButton
onready var settings_button: Button = $ButtonContainer/SettingsButton
onready var quit_button: Button = $ButtonContainer/QuitButton
onready var main_settings_menu: Control = $MainSettingsMenu

func _ready() -> void:
	CoreFunctions.unpause_tree()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), \
		linear2db(SaveLoad.globalData.GlobalVolume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), \
		linear2db(SaveLoad.globalData.SFXVolume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UISFX"), \
		linear2db(SaveLoad.globalData.UISFXVolume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), \
		linear2db(SaveLoad.globalData.MusicVolume))
	if SaveLoad.levelSpecificData["FreezeTutorialNL"].FirstTime == true:
		glossary_button.disabled = true
		level_selector_button.text = "Play"
	else:
		glossary_button.disabled = false
	if ControllerSupport.joypadInUse:
		level_selector_button.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel") \
	and ControllerSupport.joypadInUse and main_settings_menu.camera_2d.current == true:
		main_settings_menu._on_CancelButton_pressed()


#                                     *
#                                     *
###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################
#                                     *
#                                     *

func _on_LevelSelectorButton_pressed() -> void:
	UISFXManager.play("Click1")
	if SaveLoad.levelSpecificData["FreezeTutorialNL"].FirstTime == true:
		SceneChanger.change_scene("res://scenes/levels/nonLevels/FreezeTutorialNL.tscn", 0.3)
	else:
		SceneChanger.change_scene("res://scenes/menus/LevelSelector.tscn", 0.3)

func _on_GlossaryButton_pressed() -> void:
	UISFXManager.play("Click1")
	SceneChanger.change_scene("res://scenes/glossary/Glossary.tscn", 0.3)

func _on_SettingsButton_pressed() -> void:
	UISFXManager.play("Click1")
	main_settings_menu.camera_2d.current = true
	main_settings_menu._update()

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
