extends Control

const ZERO_STARS = preload("res://sprites/gui/0_stars_shrunk.png")
const ONE_STAR = preload("res://sprites/gui/1_stars_shrunk.png")
const TWO_STARS = preload("res://sprites/gui/2_stars_shrunk.png")
const THREE_STARS = preload("res://sprites/gui/3_stars_shrunk.png")
const MASTER_STARS = preload("res://sprites/gui/master_stars_shrunk.png")

onready var easyButton = $DifficultyButtons/HBoxContainer/EasyButton
onready var mediumButton = $DifficultyButtons/HBoxContainer/MediumButton
onready var hardButton = $DifficultyButtons/HBoxContainer/HardButton
onready var expertButton = $DifficultyButtons/HBoxContainer/ExpertButton

onready var modeLabel = CoreFunctions.get_main_node().get_node("ModeLabel")
onready var abilitiesLabel = CoreFunctions.get_main_node().get_node("AbilitiesLabel")
onready var recordLabel = CoreFunctions.get_main_node().get_node("RecordLabel")
onready var starsImage = CoreFunctions.get_main_node().get_node("StarsImage")
onready var levelImage = CoreFunctions.get_main_node().get_node("LevelImage")
onready var modifiersLabel = CoreFunctions.get_main_node().get_node("ModifiersLabel")
onready var starsEarnedLabel = CoreFunctions.get_main_node().get_node("StarsEarnedLabel")
onready var masterStarsEarnedLabel = CoreFunctions.get_main_node().get_node("MasterStarsEarnedLabel")

onready var easyLevels = $EasyLevels
onready var mediumLevels = $MediumLevels
onready var hardLevels = $HardLevels
onready var expertLevels = $ExpertLevels
onready var background = $Background

onready var BtnGroup = ButtonGroup.new()

var buttonPressed : String = ""

var justLoadedIn : bool = true

func _ready() -> void:
	easyButton.group = BtnGroup
	mediumButton.group = BtnGroup
	hardButton.group = BtnGroup
	expertButton.group = BtnGroup
	easyButton.pressed = false
	mediumButton.pressed = false
	hardButton.pressed = false
	expertButton.pressed = false
	if "Level_1_" in CoreFunctions.previousSceneName:
		easyButton.pressed = true
		button_checker("easy")
	elif "Level_2_" in CoreFunctions.previousSceneName:
		mediumButton.pressed = true
		button_checker("medium")
	elif "Level_3_" in CoreFunctions.previousSceneName:
		hardButton.pressed = true
		button_checker("hard")
	elif "Level_4_" in CoreFunctions.previousSceneName:
		expertButton.pressed = true
		button_checker("expert")
	else:
		easyButton.pressed = true
		button_checker("easy")
	var globalStars = SaveLoad.globalData.TotalStarsEarned
	var globalMasterStars = SaveLoad.globalData.TotalMasterStarsEarned
	starsEarnedLabel.text += str(globalStars)
	masterStarsEarnedLabel.text += str(globalMasterStars)

func _input(event):
	if event.is_action_pressed("ui_cancel") and ControllerSupport.joypadInUse:
		_on_MainMenuButton0_pressed()

func button_checker(button):
	match button:
		"easy":
			if not buttonPressed == "easy":
				if not justLoadedIn:
					UISFXManager.play("Swipe1")
				else:
					justLoadedIn = false
				background.modulate = Color(0, 1, 0, 1)
				buttonPressed = "easy"
				easyLevels.visible = true
				mediumLevels.visible = false
				hardLevels.visible = false
				expertLevels.visible = false
				levelImage.texture = null
				modeLabel.text = "MODE: "
				abilitiesLabel.text = "ABILITIES: "
				recordLabel.text = "RECORD:"
				modifiersLabel.text = "MODIFIERS: "
				starsImage.texture = null
				if ControllerSupport.joypadInUse == true:
					$EasyLevels/Button1.grab_focus()
		"medium":
			if not buttonPressed == "medium":
				if not justLoadedIn:
					UISFXManager.play("Swipe1")
				else:
					justLoadedIn = false
				background.modulate = Color(0, 0, 1, 1)
				buttonPressed = "medium"
				easyLevels.visible = false
				mediumLevels.visible = true
				hardLevels.visible = false
				expertLevels.visible = false
				levelImage.texture = null
				modeLabel.text = "MODE: "
				abilitiesLabel.text = "ABILITIES: "
				recordLabel.text = "RECORD:"
				modifiersLabel.text = "MODIFIERS: "
				starsImage.texture = null
				if ControllerSupport.joypadInUse == true:
					$MediumLevels/Button1.grab_focus()
		"hard":
			if not buttonPressed == "hard":
				if not justLoadedIn:
					UISFXManager.play("Swipe1")
				else:
					justLoadedIn = false
				background.modulate = Color(1, 0, 0, 1)
				buttonPressed = "hard"
				easyLevels.visible = false
				mediumLevels.visible = false
				hardLevels.visible = true
				expertLevels.visible = false
				levelImage.texture = null
				modeLabel.text = "MODE: "
				abilitiesLabel.text = "ABILITIES: "
				recordLabel.text = "RECORD:"
				modifiersLabel.text = "MODIFIERS: "
				starsImage.texture = null
				if ControllerSupport.joypadInUse == true:
					$HardLevels/Button1.grab_focus()
		"expert":
			if not buttonPressed == "expert":
				if not justLoadedIn:
					UISFXManager.play("Swipe1")
				else:
					justLoadedIn = false
				background.modulate = Color(0.1, 0.1, 0.1, 1)
				buttonPressed = "expert"
				easyLevels.visible = false
				mediumLevels.visible = false
				hardLevels.visible = false
				expertLevels.visible = true
				levelImage.texture = null
				modeLabel.text = "MODE: "
				abilitiesLabel.text = "ABILITIES: "
				recordLabel.text = "RECORD:"
				modifiersLabel.text = "MODIFIERS: "
				starsImage.texture = null
				if ControllerSupport.joypadInUse == true:
					$ExpertLevels/Button1.grab_focus()

func _on_EasyButton_pressed() -> void:
	button_checker("easy")

func _on_MediumButton_pressed() -> void:
	button_checker("medium")

func _on_HardButton_pressed() -> void:
	button_checker("hard")

func _on_ExpertButton_pressed() -> void:
	button_checker("expert")

func update_stars(levelName : String):
	if SaveLoad.levelSpecificData.has(levelName):
		match SaveLoad.levelSpecificData[levelName].StarsEarned:
			-1:
				starsImage.texture = null
			0:
				starsImage.texture = ZERO_STARS
			1:
				starsImage.texture = ONE_STAR
			2:
				starsImage.texture = TWO_STARS
			3:
				starsImage.texture = THREE_STARS
		if SaveLoad.levelSpecificData[levelName].MasterStarsEarned == 1:
			starsImage.texture = MASTER_STARS
		if SaveLoad.levelSpecificData[levelName].TimeRecord >= 0 \
		and not SaveLoad.levelSpecificData[levelName].TimeRecord == 12345:
			var timeRecord = SaveLoad.levelSpecificData[levelName].TimeRecord
			var ms = int(round(fmod(timeRecord, 1) * 1000))
			var seconds = fmod(timeRecord, 60)
			var minutes = fmod(timeRecord, 3600) / 60
			var strRecord = "%01d:%02d:%03d" % [minutes, seconds, ms]
			recordLabel.text = ("RECORD:\n" + strRecord)
		else:
			recordLabel.text = "RECORD:\nNone yet"

func _on_MainMenuButton0_pressed() -> void:
	UISFXManager.play("Click2")
	SceneChanger.change_scene("res://scenes/menus/MainMenu.tscn", 0.3)
