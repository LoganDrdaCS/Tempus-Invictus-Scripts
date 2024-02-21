extends Control

class_name Glossary_Item

var returnButton : Button
var videoPlayer : VideoPlayer

func _ready() -> void:
	returnButton = CoreFunctions.get_main_node().get_node("ReturnButton")
	videoPlayer = CoreFunctions.get_main_node().get_node_or_null("VideoPlayer")
	if not videoPlayer == null:
		videoPlayer.connect("finished", self, "_restart_video")
	returnButton.connect("pressed", self, "_return")
	if ControllerSupport.joypadInUse:
		returnButton.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel") and ControllerSupport.joypadInUse:
		_return()

func _return() -> void:
	UISFXManager.play("Click2")
	SceneChanger.change_scene("res://scenes/glossary/Glossary.tscn", 0.3)

func _restart_video() -> void:
	videoPlayer.play()
