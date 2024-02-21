extends Control

onready var centeredLabelDefault = $CenteredLabelDefault

onready var player = CoreFunctions.get_player()
onready var enemyCounter = CoreFunctions.get_main_node().get_node("HUD").get_node("EnemyCounter")
onready var gameTimer = CoreFunctions.get_main_node().get_node("HUD").get_node("GameTimer")
onready var enemyManager = CoreFunctions.get_main_node().get_node("Managers").get_node("EnemyManager")
onready var preTimer = CoreFunctions.get_main_node().get_node("HUD").get_node("PreTimer")
onready var ammoLabel = CoreFunctions.get_main_node().get_node("HUD").get_node("AmmoLabel")

onready var quickRestartLabel = $QuickRestartLabel
onready var arrowLabel = $ArrowLabel

var textNumber : int = 0

func _physics_process(delta: float) -> void:
#	if enemyCounter.enemies == 0:
#		quickRestartLabel.visible = true
#	else:
#		quickRestartLabel.visible = false
	if textNumber == 0:
		pass
	else:
		pass
	if Input.is_action_just_pressed("ui_left"):
		if not textNumber == 0:
			textNumber -= 1
			textNumber_checker()
	elif Input.is_action_just_pressed("ui_right"):
		if not textNumber == 8:
			textNumber += 1
			textNumber_checker()

func textNumber_checker():
	match textNumber:
		0:
			centeredLabelDefault.text = "FLOW MODE TUTORIAL"
		1:
			centeredLabelDefault.text = "FLOW mode has three main differences from FREEZE mode:"
			arrowLabel.visible = true
		2:
			centeredLabelDefault.text = "FLOW mode has three main differences from FREEZE mode:\nThere is no hourglass"
		3:
			centeredLabelDefault.text = "FLOW mode has three main differences from FREEZE mode:\nThere is no hourglass\nThe level ends once all enemies are eliminated"
		4:
			centeredLabelDefault.text = "FLOW mode has three main differences from FREEZE mode:\nThere is no hourglass\nThe level ends once all enemies are eliminated\nThe world is only frozen during Burst or Stasis"
		5:
			centeredLabelDefault.text = "Try shooting and using Burst ('F' key) or Stasis (right mouse button) to get familiarized with this mode"
		6:
			centeredLabelDefault.text = "Notice that you can pass through enemies when time is not frozen"
		7:
			centeredLabelDefault.text = "Remember to go through the Glossary on the main menu to learn all about your abilities and items, as well as enemies you will encounter!"
		8:
			centeredLabelDefault.text = "Pause ('ESC' key) to return to the Main Menu or the Level Selector"




