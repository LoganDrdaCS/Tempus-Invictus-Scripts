extends CanvasLayer

# STILL NEEDS A LOOKTHROUGH

onready var animation_player: AnimationPlayer = $AnimationPlayer

# path is string that points to path of file to load
# delay is how long to wait before starting to fade
func change_scene(path, delay = 0.3):
	CoreFunctions.previousSceneName = CoreFunctions.get_main_node().name
	yield(get_tree().create_timer(delay), "timeout")
	if OS.window_fullscreen:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	animation_player.play("fade")
	# this next line makes use of a signal from the animation_player to wait
	# until that signal is received
	yield(animation_player, "animation_finished")
	CoreFunctions.unpause_tree()
	
	# next line will cause game to crash if the path doesn't exist
#	var result = get_tree().change_scene(path)
#	assert(result == OK)
	get_tree().change_scene(path)
	
#	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) # for export
	if OS.window_fullscreen:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# controller support "if":
	if ControllerSupport.joypadInUse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animation_player.play_backwards("fade")
	BusForSignals.emit_signal("scene_changed")
