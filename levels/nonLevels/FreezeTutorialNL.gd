extends Control

onready var centeredLabelDefault = $CenteredLabelDefault

onready var hourglass = CoreFunctions.get_main_node().get_node("LevelDesign/Hourglass")
onready var player = CoreFunctions.get_player()
onready var enemyCounter = CoreFunctions.get_main_node().get_node("HUD").get_node("EnemyCounter")
onready var gameTimer = CoreFunctions.get_main_node().get_node("HUD").get_node("GameTimer")
onready var enemyManager = CoreFunctions.get_main_node().get_node("Managers").get_node("EnemyManager")
onready var preTimer = CoreFunctions.get_main_node().get_node("HUD").get_node("PreTimer")
onready var ammoLabel = CoreFunctions.get_main_node().get_node("HUD").get_node("AmmoLabel")

onready var arrowLabel = $ArrowLabel
onready var timerArrow = $TimerArrow
onready var enemyCounterArrow = $EnemyCounterArrow
onready var ammoCounterArrow = $AmmoCounterArrow
onready var HUDArrow = $HUDArrow
onready var preTimerArrow = $PreTimerArrow
onready var hourglassArrow = $HourglassArrow
onready var quickRestartLabel = $QuickRestartLabel

var textNumber : int = 0

func _ready() -> void:
	player.aimRotator.visible = false
	hourglass.visible = false
	arrowLabel.visible = false
#	gameTimer.visible = false
#	enemyCounter.visible = false
#	timerLabel.visible = false
#	enemyCounterLabel.visible = false
	enemyManager.visible = false
	yield(CoreFunctions.get_main_node(), "ready")
	enemyCounter.counterLabel.text = "0"
	player.canPause = false
	player.canMove = false
	player.canShoot = false
	player.canBurst = false
	player.burstOverridden = true
	player.canStasis = false
	player.stasisOverridden = true
	player.canQuickRestart = false
	player.quickRestartOverridden = true
	player.canToggleFullscreen = false
	player.canJump = false
	player.canTether = false
	player.tetherOverridden = true
	player.canBomb = false
	if SaveLoad.levelSpecificData["FreezeTutorialNL"].FirstTime == false:
		player.canPause = true
		quickRestartLabel.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_viewport().warp_mouse(Vector2(1920 * 0.5, 1080 * 0.8))

func _physics_process(delta: float) -> void:
	if textNumber == 0:
		pass
	else:
		pass
	if Input.is_action_just_pressed("ui_left"):
		if not textNumber == 0:
			textNumber -= 1
			textNumber_checker()
	elif Input.is_action_just_pressed("ui_right"):
		if not textNumber == 36:
			textNumber += 1
			textNumber_checker()
	if textNumber == 4:
		timerArrow.visible = true
	else:
		timerArrow.visible = false
	if textNumber == 5:
		enemyCounterArrow.visible = true
	else:
		enemyCounterArrow.visible = false
	if textNumber == 6:
		ammoCounterArrow.visible = true
	else:
		ammoCounterArrow.visible = false
	if textNumber == 7:
		HUDArrow.visible = true
		preTimer.visible = false
		ammoLabel.visible = false
	else:
		HUDArrow.visible = false
		preTimer.visible = true
		ammoLabel.visible = true
	if textNumber == 8:
		preTimerArrow.visible = true
	else:
		preTimerArrow.visible = false
	if textNumber == 14:
		hourglassArrow.visible = true
	else:
		hourglassArrow.visible = false

func textNumber_checker():
	match textNumber:
		0:
			centeredLabelDefault.text = "Welcome to Time Shot!\nLeft arrow key = Previous\nRight arrow key = Next"
		1:
			arrowLabel.visible = true
			centeredLabelDefault.text = "There are two primary modes of gameplay:"
		2:
			centeredLabelDefault.text = "There are two primary modes of gameplay:\nFREEZE mode"
		3:
			centeredLabelDefault.text = "There are two primary modes of gameplay:\nFREEZE mode\nand FLOW mode"
		4:
			centeredLabelDefault.text = "This is the main timer. It will not begin until you make your first move."
		5:
			centeredLabelDefault.text = "This is the enemy counter."
		6:
			centeredLabelDefault.text = "This is your ammo counter."
		7:
			centeredLabelDefault.text = "This is your equipment and ability cooldown HUD."
		8:
			centeredLabelDefault.text = "This is the pre-timer, which will stop once you perform your first action. It helps you begin your run at a desired time."
		9:
			centeredLabelDefault.text = "In FREEZE mode, making your first move in a run will freeze the world around you."
		10:
			centeredLabelDefault.text = "This includes enemies, most moving platforms, and most of your own projectiles."
		11:
			enemyCounter._update()
			enemyManager.visible = true
			centeredLabelDefault.text = "Here is your first enemy, the SPECTRE."
		12:
			player.canMove = true
			centeredLabelDefault.text = "Try moving to freeze the surrounding world. Use the 'A' or 'D' keys to move.\nNotice that the pre-timer stops and the main timer begins."
		13:
			player.canShoot = true
			player.aimRotator.visible = true
			if OS.window_fullscreen:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			centeredLabelDefault.text = "Try shooting the enemy a few times. Use the left mouse button for this."
		14:
			hourglass.visible = true
			centeredLabelDefault.text = "This is the hourglass, which is only in FREEZE mode."
		15:
			centeredLabelDefault.text = "Coming into contact with the hourglass will do 3 things:"
		16:
			centeredLabelDefault.text = "Coming into contact with the hourglass will do 3 things:\nUnfreeze the world"
		17:
			centeredLabelDefault.text = "Coming into contact with the hourglass will do 3 things:\nUnfreeze the world\nStop the main timer"
		18:
			centeredLabelDefault.text = "Coming into contact with the hourglass will do 3 things:\nUnfreeze the world\nStop the main timer\nDisable further attacks"
		19:
			centeredLabelDefault.text = "Contacting the hourglass is how you complete a FREEZE mode level."
		20:
			player.canJump = true
			centeredLabelDefault.text = "Try multi-jumping into the hourglass. Use the spacebar to jump.\nHold the jump button for a higher jump each time."
		21:
			centeredLabelDefault.text = "If all enemies were eliminated, the level was successfully passed..."
		22:
			centeredLabelDefault.text = "...and your resulting time will be rated, ranging from 0 to 3 stars. There is no rating for this tutorial."
		23:
			centeredLabelDefault.text = "Stars are used to gauge your performance and for unlockables."
		24:
			centeredLabelDefault.text = "Your personal record for each level will be located under the main timer. There is no record for this tutorial."
		25:
			centeredLabelDefault.text = "To instantly restart any level at any point in time, use the QUICK RESTART feature."
		26:
			player.quickRestartOverridden = false
			player.canQuickRestart = true
			centeredLabelDefault.text = "Try quick restarting with the middle mouse button now."
		27:
			centeredLabelDefault.text = "A brief introduction to the 4 abilities will now be provided."
		28:
			centeredLabelDefault.text = "The abilities are BURST, STASIS, TETHER, and TOGGLE CAMERA. You cannot use these abilities after the hourglass has been contacted. A quick restart will be required."
		29:
			centeredLabelDefault.text = "Burst is a time-based ability which pauses the world and timer for 3 seconds. Activated using the 'F' key."
			player.burstOverridden = false
			player.canBurst = true
#			BusForSignals.emit_signal("restart_initiated")
		30:
			centeredLabelDefault.text = "Stasis is a hybrid ability which freezes everything in the game, including yourself, for 4 seconds (useful in the air). You can still shoot during this time. Activated using the right mouse button."
			player.canStasis = true
			player.stasisOverridden = false
#			BusForSignals.emit_signal("restart_initiated")
		31:
			centeredLabelDefault.text = "Tether is a movement ability which allows you to teleport to a designated location twice during a run. Activated using the 'T' key."
			player.tetherOverridden = false
			player.canTether = true
#			BusForSignals.emit_signal("restart_initiated")
		32:
			centeredLabelDefault.text = "Toggle Camera is a scouting ability which allows you to see the entire level before your run. Activated using the 'X' key prior to your first move. (Only for use on some levels.)"
		33:
			centeredLabelDefault.text = "When playing through the campaign, you will see which abilities are permitted on each level."
		34:
			centeredLabelDefault.text = "Try using BURST ('F' key), STASIS (right mouse button), and TETHER ('T' key) to get the hang of each ability. You may need to quick restart to be able to use them."
		35:
			centeredLabelDefault.text = "For in-depth explanations, video examples, and tutorials of FLOW mode, player abilities, items, and enemies, see the GLOSSARY on the main menu!"
		36:
			SaveLoad.levelSpecificData["FreezeTutorialNL"].FirstTime = false
#			SaveLoad.globalData.GlossaryUnlocked = true
			SaveLoad.save_data()
			player.pauseOverridden = false
			player.canPause = true
			centeredLabelDefault.text = "You can continue practicing by quick restarting, or you can pause and choose 'Level Selector' to start the campaign."
