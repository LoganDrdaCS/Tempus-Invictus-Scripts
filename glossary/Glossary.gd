extends Control

onready var BurstButton = $VBoxContainer/BurstButton

func _ready() -> void:
	if ControllerSupport.joypadInUse:
		BurstButton.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel") and ControllerSupport.joypadInUse:
		_on_ReturnButton_pressed()

func _on_ReturnButton_pressed() -> void:
	UISFXManager.play("Click2")
	SceneChanger.change_scene("res://scenes/menus/MainMenu.tscn", 0.3)

func _on_BurstButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Burst.tscn", 0.3)

func _on_StasisButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Stasis.tscn", 0.3)

func _on_ToggleCameraButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Toggle_Camera.tscn", 0.3)

func _on_TetherButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Tether.tscn", 0.3)

func _on_BombButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Bomb.tscn", 0.3)

func _on_FreezeModeButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/levels/nonLevels/FreezeTutorialNL.tscn", 0.3)

func _on_EtherealButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Ethereal.tscn", 0.3)

func _on_FloatBotButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_FloatBot.tscn", 0.3)

func _on_FloorBotButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_FloorBot.tscn", 0.3)

func _on_ShieldBotButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_ShieldBot.tscn", 0.3)

func _on_SpectreButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Spectre.tscn", 0.3)

func _on_ZombieButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Zombie.tscn", 0.3)

func _on_IntruderButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Intruder.tscn", 0.3)

func _on_PlatformPotionButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Platform_Potion.tscn", 0.3)

func _on_ThornButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/glossary/Glossary_Thorn.tscn", 0.3)

func _on_FlowModeButton_pressed() -> void:
	UISFXManager.play("Click3")
	SceneChanger.change_scene("res://scenes/levels/nonLevels/FlowTutorialNL.tscn", 0.3)
