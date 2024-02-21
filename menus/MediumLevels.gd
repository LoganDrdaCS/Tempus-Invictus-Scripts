extends VBoxContainer

onready var modeLabel = CoreFunctions.get_main_node().get_node("ModeLabel")
onready var abilitiesLabel = CoreFunctions.get_main_node().get_node("AbilitiesLabel")
onready var levelImage = CoreFunctions.get_main_node().get_node("LevelImage")
onready var recordLabel = CoreFunctions.get_main_node().get_node("RecordLabel")
onready var starsImage = CoreFunctions.get_main_node().get_node("StarsImage")
onready var modifiersLabel = CoreFunctions.get_main_node().get_node("ModifiersLabel")

onready var mainNode = CoreFunctions.get_main_node()

func _ready() -> void:
	pass


func _on_Button1_mouse_entered() -> void:
	modeLabel.text = "MODE: Freeze"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_2_1.png")
	mainNode.update_stars("Level_2_1")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button2_mouse_entered() -> void:
	modeLabel.text = "MODE: Freeze"
	abilitiesLabel.text = "ABILITIES: Burst, Stasis"
	#levelImage.texture = load("res://sprites/levelImages/Level_2_2.png")
	mainNode.update_stars("Level_2_2")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button3_mouse_entered() -> void:
	modeLabel.text = "MODE: Freeze"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_2_3.png")
	mainNode.update_stars("Level_2_3")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button4_mouse_entered() -> void:
	modeLabel.text = "MODE: Freeze"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_2_4.png")
	mainNode.update_stars("Level_2_4")
	modifiersLabel.text = "MODIFIERS: None"

func _on_Button5_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_2_5.png")
	mainNode.update_stars("Level_2_5")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button6_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_2_6.png")
	mainNode.update_stars("Level_2_6")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button7_mouse_entered() -> void:
	modeLabel.text = "MODE: Freeze"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_2_7.png")
	mainNode.update_stars("Level_2_7")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button8_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_2_8.png")
	mainNode.update_stars("Level_2_8")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button9_mouse_entered() -> void:
	modeLabel.text = "MODE: Freeze"
	abilitiesLabel.text = "ABILITIES: Burst, Stasis, Tether"
	#levelImage.texture = load("res://sprites/levelImages/Level_2_9.png")
	mainNode.update_stars("Level_2_9")
	modifiersLabel.text = "MODIFIERS: Fullscreen"



func _on_Button1_pressed() -> void:
	UISFXManager.play("Click3")
#	SceneChanger.change_scene("res://scenes/levels/Level_2_1.tscn", 0.3)
	SceneChanger.change_scene("res://scenes/levels/PreLevel_2_1.tscn", 0.3)


func _on_Button2_pressed() -> void:
	UISFXManager.play("Click3")
#	SceneChanger.change_scene("res://scenes/levels/Level_2_2.tscn", 0.3)
	SceneChanger.change_scene("res://scenes/levels/PreLevel_2_2.tscn", 0.3)


func _on_Button3_pressed() -> void:
	UISFXManager.play("Click3")
#	SceneChanger.change_scene("res://scenes/levels/Level_2_3.tscn", 0.3)
	SceneChanger.change_scene("res://scenes/levels/PreLevel_2_3.tscn", 0.3)


func _on_Button4_pressed() -> void:
	UISFXManager.play("Click3")
#	SceneChanger.change_scene("res://scenes/levels/Level_2_4.tscn", 0.3)
	SceneChanger.change_scene("res://scenes/levels/PreLevel_2_4.tscn", 0.3)


func _on_Button5_pressed() -> void:
	UISFXManager.play("Click3")
#	SceneChanger.change_scene("res://scenes/levels/Level_2_5.tscn", 0.3)
	SceneChanger.change_scene("res://scenes/levels/PreLevel_2_5.tscn", 0.3)


func _on_Button6_pressed() -> void:
	UISFXManager.play("Click3")
#	SceneChanger.change_scene("res://scenes/levels/Level_2_6.tscn", 0.3)
	SceneChanger.change_scene("res://scenes/levels/PreLevel_2_6.tscn", 0.3)


func _on_Button7_pressed() -> void:
	UISFXManager.play("Click3")
#	SceneChanger.change_scene("res://scenes/levels/Level_2_7.tscn", 0.3)
	SceneChanger.change_scene("res://scenes/levels/PreLevel_2_7.tscn", 0.3)


func _on_Button8_pressed() -> void:
	UISFXManager.play("Click3")
#	SceneChanger.change_scene("res://scenes/levels/Level_2_8.tscn", 0.3)
	SceneChanger.change_scene("res://scenes/levels/PreLevel_2_8.tscn", 0.3)


func _on_Button9_pressed() -> void:
	UISFXManager.play("Click3")
#	SceneChanger.change_scene("res://scenes/levels/Level_2_9.tscn", 0.3)
	SceneChanger.change_scene("res://scenes/levels/PreLevel_2_9.tscn", 0.3)
