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
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_4_1.png")
	mainNode.update_stars("Level_4_1")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button2_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_4_2.png")
	mainNode.update_stars("Level_4_2")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button3_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_4_3.png")
	mainNode.update_stars("Level_4_3")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button4_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_4_4.png")
	mainNode.update_stars("Level_4_4")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button5_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_4_5.png")
	mainNode.update_stars("Level_4_5")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button6_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_4_6.png")
	mainNode.update_stars("Level_4_6")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button7_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_4_7.png")
	mainNode.update_stars("Level_4_7")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button8_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_4_8.png")
	mainNode.update_stars("Level_4_8")
	modifiersLabel.text = "MODIFIERS: None"


func _on_Button9_mouse_entered() -> void:
	modeLabel.text = "MODE: Flow"
	abilitiesLabel.text = "ABILITIES: Burst"
	#levelImage.texture = load("res://sprites/levelImages/Level_4_9.png")
	mainNode.update_stars("Level_4_9")
	modifiersLabel.text = "MODIFIERS: None"
