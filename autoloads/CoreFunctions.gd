extends Node

# STILL NEEDS A LOOKTHROUGH

var previousSceneName : String = ""

func _ready() -> void:
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func get_main_node() -> Node:
	var root_node : Node = get_tree().get_root()
	return root_node.get_child(root_node.get_child_count() - 1)

func get_player() -> Node:
	return get_main_node().get_node("Player")

func unpause_tree() -> void:
	get_tree().paused = false

func pause_tree() -> void:
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("temporary_OS_fullscreen"):
		toggle_fullscreen()
	if event.is_action_pressed("next_song"):
		BusForSignals.emit_signal("next_song")

func toggle_fullscreen() -> void:
	OS.window_fullscreen = !OS.window_fullscreen
#	yield(get_tree(), "idle_frame") ##### for export
	if OS.window_fullscreen:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if ControllerSupport.joypadInUse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
