extends Control

#var playerGhost
var is_paused = false setget set_is_paused
onready var player = CoreFunctions.get_player()
onready var mainNode = CoreFunctions.get_main_node()
onready var gameTimer = mainNode.get_node("HUD").get_node("GameTimer")
var hourglass

# internal references
onready var pauseSettingsMenu = $PauseSettingsMenu
onready var pauseLabel = $ButtonContainer/VBoxContainer/PausedLabel
onready var resumeButton = $ButtonContainer/VBoxContainer/ResumeButton
onready var selectLevelButton = $ButtonContainer/VBoxContainer/SelectLevelButton
onready var controlsButton = $ButtonContainer/VBoxContainer/ControlsButton
onready var quitButton = $ButtonContainer/VBoxContainer/QuitButton
onready var pauseSound = $AudioStreamPlayer

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	self.visible = false
	yield(CoreFunctions.get_main_node(), "ready")
	if player.mode == "Freeze":
		hourglass = CoreFunctions.get_main_node().get_node("LevelDesign").get_node("Hourglass")
	pauseSettingsMenu.visible = false
	if mainNode.name == "FlowTutorialNL" or mainNode.name == "FreezeTutorialNL":
		selectLevelButton.visible = false
	else:
		pauseLabel.text = str(mainNode.name)
#	if player.playerGhostExists:
#		playerGhost = CoreFunctions.get_main_node().get_node("PlayerGhostManager").get_node("PlayerGhost")

func _unhandled_input(event):
#	if not player.playerGhostExists:
#		if event.is_action_pressed("pause") and not player.burst and not \
#		player.stasis and not player.pauseForCameraAdjustment \
#		and player.canPause:
#			self.is_paused = !is_paused
#			pauseSettingsMenu.visible = false
#	else:
#		if event.is_action_pressed("pause") and not player.burst and not \
#		player.stasis and not player.pauseForCameraAdjustment \
#		and not playerGhost.burst and not playerGhost.stasis \
#		and player.canPause:
#			self.is_paused = !is_paused
#			pauseSettingsMenu.visible = false

# delete the following paragraph and uncomment the if-else above when using ghost.
	if event.is_action_pressed("pause") and not player.burst and not \
	player.stasis and not player.pauseForCameraAdjustment \
	and player.canPause:
		self.is_paused = !is_paused
		if self.is_paused == true:
			BusForSignals.emit_signal("player_has_paused")
			if ControllerSupport.joypadInUse:
				resumeButton.grab_focus()
		else:
			BusForSignals.emit_signal("player_has_unpaused")
		pauseSettingsMenu.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel") and ControllerSupport.joypadInUse:
		if self.visible == true and pauseSettingsMenu.visible == false:
			_on_ResumeButton_pressed()
		elif self.visible == true:
			pauseSettingsMenu._on_CancelReturnButton_pressed()

func set_is_paused(value):
	is_paused = value
	if is_paused:
		gameTimer.pause_mode = Node.PAUSE_MODE_STOP
		if mainNode.has_node("LevelDesign"):
			if mainNode.get_node("LevelDesign").has_node("Hourglass"):
				hourglass.pause_mode = Node.PAUSE_MODE_STOP
		if OS.window_fullscreen:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if ControllerSupport.joypadInUse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.pause_mode = Node.PAUSE_MODE_STOP
#		if player.playerGhostExists:
#			playerGhost.pause_mode = Node.PAUSE_MODE_STOP
	else:
		gameTimer.pause_mode = Node.PAUSE_MODE_PROCESS
		if mainNode.has_node("LevelDesign"):
			if mainNode.get_node("LevelDesign").has_node("Hourglass"):
				hourglass.pause_mode = Node.PAUSE_MODE_PROCESS
		if OS.window_fullscreen:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if ControllerSupport.joypadInUse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
#		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) # for export
		player.pause_mode = Node.PAUSE_MODE_PROCESS
#		if player.playerGhostExists:
#			playerGhost.pause_mode = Node.PAUSE_MODE_PROCESS
	if player.mode == "Freeze" and gameTimer.playerHasBegun == true:
		pass
	else:
		get_tree().paused = is_paused
	self.visible = is_paused
	if self.visible == true:
		pauseSound.play()

###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################

func _on_ResumeButton_pressed():
	UISFXManager.play("Click1")
	self.is_paused = false
	BusForSignals.emit_signal("player_has_unpaused")

func _on_SelectLevelButton_pressed():
	UISFXManager.play("Click1")
	SceneChanger.change_scene("res://scenes/menus/LevelSelector.tscn", 0.3)

func _on_ControlsButton_pressed():
	UISFXManager.play("Click1")
	pauseSettingsMenu.visible = true
	if ControllerSupport.joypadInUse:
		pauseSettingsMenu.cancelReturnButton.grab_focus()

func _on_QuitButton_pressed():
	UISFXManager.play("Click2")
	SceneChanger.change_scene("res://scenes/menus/MainMenu.tscn", 0.3) # path, delay
#	yield(get_tree().create_timer(0.3), "timeout")
	$Timer.start(0.3); yield($Timer, "timeout")
	self.visible = false
#	yield(get_tree().create_timer(0.3), "timeout")
	$Timer.start(0.3); yield($Timer, "timeout")
	self.is_paused = false

func _restart() -> void:
	self.is_paused = false
	BusForSignals.emit_signal("player_has_unpaused")
