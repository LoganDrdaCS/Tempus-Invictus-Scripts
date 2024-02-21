extends Control

onready var pauseMenu = self.get_parent()

# internal references
#onready var saveReturnButton = $Panel/ReturnButtonContainer/SaveReturnButton
onready var cancelReturnButton = $Panel/ReturnButtonContainer/CancelReturnButton
#onready var randomizeColorButton = $Panel/RightColumn/RandomizeColorButton
#onready var colorLabel = $Panel/RightColumn/ColorLabel
#onready var colorPicker = $Panel/RightColumn/ColorPicker
#onready var resetColorButton = $Panel/RightColumn/ResetColorButton

onready var currentLevelName = CoreFunctions.get_main_node().name

#var colorRandomized : bool
#var playerColor : Color

func _ready():
	self.visible = false
#	if not (currentLevelName == "TutorialPart1" or currentLevelName == "TutorialPart2" or \
#	currentLevelName == "TutorialPart3" or currentLevelName == "TestEnvironment" or \
#	currentLevelName == "TestEnvironment2" or currentLevelName == "TESTLEVEL"):
#		if SaveLoad.levelSpecificData.has(currentLevelName):
#			if SaveLoad.levelSpecificData[currentLevelName].PlayerColor == null:
#				randomizeColorButton.pressed = true
#				colorRandomized = true
#			else:
#				randomizeColorButton.pressed = false
#				colorRandomized = false
#				colorLabel.visible = true
#				colorPicker.visible = true
#				colorPicker.color = SaveLoad.levelSpecificData[currentLevelName].PlayerColor
#				resetColorButton.visible = true
#		else:
#				randomizeColorButton.pressed = true
#				colorRandomized = true
#	else:
#		randomizeColorButton.pressed = true
#		colorRandomized = true

#func _on_RandomizeColorButton_toggled(button_pressed: bool) -> void:
#	colorRandomized = !colorRandomized
#	if colorRandomized == true:
#		colorLabel.visible = false
#		colorPicker.visible = false
#		resetColorButton.visible = false
#	else:
#		colorLabel.visible = true
#		colorPicker.visible = true
#		resetColorButton.visible = true


#func _on_ColorPicker_color_changed(color: Color) -> void:
#	playerColor = color
#
#
#func _on_ResetColorButton_pressed() -> void:
#	colorPicker.color = Color(1, 1, 1, 1)
#	playerColor = Color(1, 1, 1, 1)

#func _on_SaveReturnButton_pressed():
#	UISFXManager.play("Click3")
##	if colorRandomized:
##		SaveLoad.levelSpecificData[currentLevelName].PlayerColor = null
##	else:
##		SaveLoad.levelSpecificData[currentLevelName].PlayerColor = playerColor
##	SaveLoad.save_data()
#	self.visible = false



func _on_CancelReturnButton_pressed():
	UISFXManager.play("Click3")
#	_ready()
	self.visible = false
	if ControllerSupport.joypadInUse:
		pauseMenu.resumeButton.grab_focus()
