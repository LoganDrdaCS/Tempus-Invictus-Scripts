extends Control

onready var main_menu = CoreFunctions.get_main_node()
onready var camera_2d: Camera2D = $Camera2D
onready var save_button: Button = $SaveCancelButtonContainer/SaveButton
onready var cancel_button: Button = $SaveCancelButtonContainer/CancelButton
onready var global_volume_slider: HSlider = $GlobalVolumeSlider
onready var sfx_volume_slider: HSlider = $SFXVolumeSlider
onready var uisfx_volume_slider: HSlider = $UISFXVolumeSlider
onready var music_volume_slider: HSlider = $MusicVolumeSlider
onready var gunshotSound = $Gunshot

var originalGlobalSoundLevel : float
var originalSFXSoundLevel : float
var originalUISFXSoundLevel : float
var originalMusicSoundLevel : float

var chosenGlobalSoundLevel : float
var chosenSFXSoundLevel : float
var chosenUISFXSoundLevel : float
var chosenMusicSoundLevel : float

func _update():
	originalGlobalSoundLevel = SaveLoad.globalData["GlobalVolume"]
	chosenGlobalSoundLevel = originalGlobalSoundLevel
	global_volume_slider.value = originalGlobalSoundLevel

	originalSFXSoundLevel = SaveLoad.globalData["SFXVolume"]
	chosenSFXSoundLevel = originalSFXSoundLevel
	sfx_volume_slider.value = originalSFXSoundLevel
	
	originalUISFXSoundLevel = SaveLoad.globalData["UISFXVolume"]
	chosenUISFXSoundLevel = originalUISFXSoundLevel
	uisfx_volume_slider.value = originalUISFXSoundLevel
	
	originalMusicSoundLevel = SaveLoad.globalData["MusicVolume"]
	chosenMusicSoundLevel = originalMusicSoundLevel
	music_volume_slider.value = originalMusicSoundLevel
	
	if ControllerSupport.joypadInUse:
		global_volume_slider.grab_focus()

#                                     *
#                                     *
###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################
#                                     *
#                                     *

func _on_SaveButton_pressed() -> void:
	UISFXManager.play("Click3")
	SaveLoad.globalData.GlobalVolume = chosenGlobalSoundLevel
	SaveLoad.globalData.SFXVolume = chosenSFXSoundLevel
	SaveLoad.globalData.UISFXVolume = chosenUISFXSoundLevel
	SaveLoad.globalData.MusicVolume = chosenMusicSoundLevel
	SaveLoad.save_data()
	main_menu.camera_2d.current = true
	if ControllerSupport.joypadInUse:
		main_menu.level_selector_button.grab_focus()

func _on_CancelButton_pressed() -> void:
	UISFXManager.play("Click3")
	main_menu.camera_2d.current = true
	main_menu._ready()

func _on_GlobalVolumeSlider_value_changed(value: float) -> void:
	chosenGlobalSoundLevel = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), \
		linear2db(chosenGlobalSoundLevel))

func _on_SFXVolumeSlider_value_changed(value: float) -> void:
	chosenSFXSoundLevel = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), \
		linear2db(chosenSFXSoundLevel))
	if ControllerSupport.joypadInUse:
		gunshotSound.play()

func _on_UISFXVolumeSlider_value_changed(value: float) -> void:
	chosenUISFXSoundLevel = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UISFX"), \
		linear2db(chosenUISFXSoundLevel))
	if ControllerSupport.joypadInUse:
		UISFXManager.play("Click2")

func _on_MusicVolumeSlider_value_changed(value: float) -> void:
	chosenMusicSoundLevel = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), \
		linear2db(chosenMusicSoundLevel))

func _on_SFXVolumeSlider_drag_ended(value_changed: bool) -> void:
	gunshotSound.play()

func _on_UISFXVolumeSlider_drag_ended(value_changed: bool) -> void:
	UISFXManager.play("Click2")
