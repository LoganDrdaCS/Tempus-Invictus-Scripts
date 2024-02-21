extends Control

var time : float
var playerHasBegun : bool = false
var levelHighScore
var levelsWithScore : Array

# external references
onready var player = CoreFunctions.get_player()
onready var currentLevelName = CoreFunctions.get_main_node().name
onready var pauseMenu = CoreFunctions.get_main_node().get_node("HUD").get_node("PauseMenu")

# internal references
onready var timeLabel = $TimeLabel
onready var recordLabel = $RecordLabel
onready var newHighScoreAnimation = $NewHighScorePanel/AnimationPlayer
onready var newHighScorePanel = $NewHighScorePanel

# controller support
var leftStickAxisX : float
var leftStickAxisY : float
var leftJoystickDeadzone = ControllerSupport.leftJoystickDeadzone
var leftJoystickCurve = ControllerSupport.leftJoystickCurve

var hourglass : bool = false

func _ready():
	time = 0.0
	timeLabel.text = "0:00:000"
	BusForSignals.connect("all_enemies_killed", self, "_all_enemies_killed")
	BusForSignals.connect("restart_initiated", self, "_restart")
	BusForSignals.connect("hourglass_contacted", self, "_hourglass_contacted")
	# test next line
	BusForSignals.connect("player_has_begun", self, "_player_has_begun")
	if SaveLoad.levelSpecificData.has(currentLevelName):
		levelHighScore = SaveLoad.levelSpecificData[currentLevelName].TimeRecord
		recordLabel.visible = true
		if levelHighScore == 12345:
			recordLabel.text = ("No record as of yet")
		elif levelHighScore > 0:
			show_high_score(levelHighScore)
		else:
			recordLabel.visible = false
	else:
		recordLabel.visible = false
#	recordLabel.visible = false # for export, although I don't really know if it's needed
	set_physics_process(false)
	
func _physics_process(delta):
	if not (player.burst or player.stasis or hourglass):
		time += delta
		var ms = int(round(fmod(time, 1) * 1000))
		var seconds = fmod(time, 60)
		var minutes = fmod(time, 3600) / 60
		var strElapsed = "%01d:%02d:%03d" % [minutes, seconds, ms]
		timeLabel.text = strElapsed

func _input(event):
	if not playerHasBegun and (player.canMove or player.canShoot) and not pauseMenu.is_paused:
		if (event is InputEventKey or event is InputEventMouseButton):
			if event.is_action_pressed("pause") or \
			event.is_action_pressed("toggle_screen") or \
			event.is_action_pressed("temporary_OS_fullscreen"):
				return
			elif (event.is_action_pressed("burst") and player.canBurst) or (event.is_action_pressed("stasis") and player.canStasis):
				get_tree().paused = true
				Physics2DServer.set_active(true)
				time = 0.0
				playerHasBegun = true
				BusForSignals.emit_signal("player_has_begun")
				time -= (1.0 / 60.0)
			elif (event.is_action_pressed("bomb") and player.canBomb and player.bombsOwned > 0) \
			or (event.is_action_pressed("jump") and player.canJump) \
			or event.is_action_pressed("attack") or (event.is_action_pressed("tether") and player.canTether) \
			or event.is_action_pressed("left") or event.is_action_pressed("right"):
				if player.mode == "Freeze":
					get_tree().paused = true
					Physics2DServer.set_active(true)
				playerHasBegun = true
				BusForSignals.emit_signal("player_has_begun")
				time = 0.0
	
#	if not playerHasBegun and (player.canMove or player.canShoot) and not pauseMenu.is_paused:
#		if event is InputEventKey:
#			if event.is_action_pressed("pause") or \
#			event.is_action_pressed("toggle_screen") or \
#			event.is_action_pressed("temporary_OS_fullscreen"):
#				return
#			elif (event.is_action_pressed("burst") and player.canBurst) or (event.is_action_pressed("stasis") and player.canStasis):
#				get_tree().paused = true
#				Physics2DServer.set_active(true)
#				time = 0.0
#				playerHasBegun = true
#				BusForSignals.emit_signal("player_has_begun")
#				time -= (1.0 / 60.0)
#			elif (event.is_action_pressed("bomb") and player.canBomb and player.bombsOwned > 0) \
#			or (event.is_action_pressed("jump") and player.canJump) \
#			or event.is_action_pressed("attack") or (event.is_action_pressed("tether") and player.canTether) \
#			or event.is_action_pressed("left") or event.is_action_pressed("right"):
#				if player.mode == "Freeze":
#					get_tree().paused = true
#					Physics2DServer.set_active(true)
#				playerHasBegun = true
#				BusForSignals.emit_signal("player_has_begun")
#				time = 0.0
#
#		elif event is InputEventMouseButton:
#			if event.is_action_pressed("pause") or \
#			event.is_action_pressed("toggle_screen") or \
#			event.is_action_pressed("temporary_OS_fullscreen"):
#				return
#			if (event.is_action_pressed("burst") and player.canBurst) or (event.is_action_pressed("stasis") and player.canStasis):
#				if player.mode == "Freeze":
#					get_tree().paused = true
#					Physics2DServer.set_active(true)
#				playerHasBegun = true
#				time = 0.0
#				BusForSignals.emit_signal("player_has_begun")
#				time -= (1.0 / 60.0)
#			elif event.is_action_pressed("quick_restart"):
#				pass
#			elif (event.is_action_pressed("bomb") and player.canBomb and player.bombsOwned > 0) \
#			or (event.is_action_pressed("jump") and player.canJump) \
#			or event.is_action_pressed("attack") or (event.is_action_pressed("tether") and player.canTether) \
#			or event.is_action_pressed("left") or event.is_action_pressed("right"):
#				if player.mode == "Freeze":
#					get_tree().paused = true
#					Physics2DServer.set_active(true)
#				playerHasBegun = true
#				BusForSignals.emit_signal("player_has_begun")
#				time = 0.0
		
		elif event is InputEventJoypadButton and ControllerSupport.joypadInUse == true:
			if event.is_action_pressed("pause") or \
			event.is_action_pressed("toggle_screen") or \
			event.is_action_pressed("temporary_OS_fullscreen"):
				return
			if (event.is_action_pressed("burst") and player.canBurst) or (event.is_action_pressed("stasis") and player.canStasis):
				if player.mode == "Freeze":
					get_tree().paused = true
					Physics2DServer.set_active(true)
				playerHasBegun = true
				time = 0.0
				BusForSignals.emit_signal("player_has_begun")
				time -= (1.0 / 60.0)
			elif event.is_action_pressed("quick_restart"):
				pass
			elif (event.is_action_pressed("bomb") and player.canBomb and player.bombsOwned > 0) \
			or (event.is_action_pressed("jump") and player.canJump) \
			or event.is_action_pressed("attack") or (event.is_action_pressed("tether") and player.canTether):
				if player.mode == "Freeze":
					get_tree().paused = true
					Physics2DServer.set_active(true)
				playerHasBegun = true
				BusForSignals.emit_signal("player_has_begun")
				time = 0.0
		
		elif event is InputEventJoypadMotion and ControllerSupport.joypadInUse == true:
			leftStickAxisX = Input.get_joy_axis(0, JOY_AXIS_0)
			leftStickAxisY = Input.get_joy_axis(0, JOY_AXIS_1)	
			if sqrt(pow(leftStickAxisX, 2) + pow(leftStickAxisY, 2)) > leftJoystickDeadzone:
				if player.mode == "Freeze":
					get_tree().paused = true
					Physics2DServer.set_active(true)
				playerHasBegun = true
				BusForSignals.emit_signal("player_has_begun")
				time = 0.0
		
#		else:
#			if ControllerSupport.joypadInUse == true:
#				if event.is_action_pressed("left_stick_left") or event.is_action_pressed("left_stick_right") \
#				or event.is_action("left_stick_left") or event.is_action("left_stick_right"):
#					if player.mode == "Freeze":
#						get_tree().paused = true
#						Physics2DServer.set_active(true)
#					playerHasBegun = true
#					BusForSignals.emit_signal("player_has_begun")
#					time = 0.0

func show_high_score(recordTime):
	var ms = int(round(fmod(recordTime, 1) * 1000))
	var seconds = fmod(recordTime, 60)
	var minutes = fmod(recordTime, 3600) / 60
	var formattedTime = "%01d:%02d:%03d" % [minutes, seconds, ms]
	recordLabel.text = ("Record = " + formattedTime)

#		                              *
#		                              *
###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################
#		                              *
#		                              *

func _all_enemies_killed():
	yield(get_tree(), "idle_frame")
	set_physics_process(false)

	if SaveLoad.levelSpecificData.has(currentLevelName):
		if levelHighScore > 0:
			compare_scores()
		elif levelHighScore == 0:
			BusForSignals.emit_signal("new_high_score")
			SaveLoad.levelSpecificData[currentLevelName].TimeRecord = time
			SaveLoad.save_data()
			if player.mode == "Freeze":
				newHighScorePanel.rect_position.y = 185
			newHighScoreAnimation.play("appear")

func compare_scores():
	if time < levelHighScore:
		BusForSignals.emit_signal("new_high_score")
		SaveLoad.levelSpecificData[currentLevelName].TimeRecord = time
		SaveLoad.save_data()
		newHighScorePanel.rect_position.y = 185
		newHighScoreAnimation.play("appear")
	else:
		BusForSignals.emit_signal("not_new_high_score")

func _hourglass_contacted():
#	self.pause_mode = Node.PAUSE_MODE_STOP
	hourglass = true
	get_tree().paused = false
#	self.set_physics_process(false)

func _restart() -> void:
	hourglass = false
#	self.pause_mode = Node.PAUSE_MODE_PROCESS
#	set_physics_process(false)
	playerHasBegun = false
#	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("left_stick_left") or Input.is_action_pressed("left_stick_right"):
#		if player.mode == "Freeze":
#			self.pause_mode = Node.PAUSE_MODE_PROCESS
#			get_tree().paused = true
#			Physics2DServer.set_active(true)
#		playerHasBegun = true
#		BusForSignals.emit_signal("player_has_begun")
#		time = 0.0
	time = 0.0
	timeLabel.text = "0:00:000"
	if SaveLoad.levelSpecificData.has(currentLevelName):
		levelHighScore = SaveLoad.levelSpecificData[currentLevelName].TimeRecord
		recordLabel.visible = true
		if levelHighScore == 12345:
			recordLabel.text = ("No record as of yet")
		elif levelHighScore > 0:
			show_high_score(levelHighScore)
		else:
			recordLabel.visible = false
	else:
		recordLabel.visible = false
	newHighScoreAnimation.play("RESET")
#	set_physics_process(true)

	yield(get_tree(), "idle_frame")
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") \
	or Input.is_action_pressed("jump"):
		if player.mode == "Freeze":
#			self.pause_mode = Node.PAUSE_MODE_PROCESS
			get_tree().paused = true
			Physics2DServer.set_active(true)
		playerHasBegun = true
		time = 0.0
		BusForSignals.emit_signal("player_has_begun")
	else:
		set_physics_process(false)
		time = 0.0

func _change_time_to(newTime):
	time = newTime
	var ms = int(round(fmod(time, 1) * 1000))
	var seconds = fmod(time, 60)
	var minutes = fmod(time, 3600) / 60
	var strElapsed = "%01d:%02d:%03d" % [minutes, seconds, ms]
	timeLabel.text = strElapsed

func _player_has_begun():
	set_physics_process(true)
