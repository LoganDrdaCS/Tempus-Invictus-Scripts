extends Node2D

var joypadInUse : bool = false
const RIGHT_JOYSTICK_DPI : int = 5000

# side note: my mouse has these DPI: 800/1600/2400/3200. I use 1600
var leftStickAxisX : float
var leftStickAxisY : float
var leftStickVector : Vector2
var rightStickAxisX : float
var rightStickAxisY : float
var rightStickVector : Vector2
var rightStickVectorDegrees : float
export(float, 0.0, 0.9) var rightJoystickDeadzone = 0.15 # radial
export(int, 0, 100) var rightJoystickSensitivity = 70
export(float, 0.0, 0.9) var leftJoystickDeadzone = 0.2 # radial

# for these curve settings, 1 is linear; the lower the value, the less finesse
export(float, 0.0, 1.0) var leftJoystickCurve = 0.75
export(float, 1.0, 5.0) var rightJoystickCurve = 3.0

func _ready() -> void:
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	if not Input.get_connected_joypads().size() == 0:
		joypadInUse = true
		self.set_physics_process(true)
		Input.warp_mouse_position(Vector2((get_tree().get_root().size.x / 2.0), \
			(get_tree().get_root().size.y / 2.0)))

func _physics_process(delta: float) -> void:
	rightStickAxisX = Input.get_joy_axis(0, JOY_AXIS_2)
	rightStickAxisY = Input.get_joy_axis(0, JOY_AXIS_3)	
	if sqrt(pow(rightStickAxisX, 2) + pow(rightStickAxisY, 2)) > rightJoystickDeadzone:
		if rightStickAxisX > 0.0:
			rightStickAxisX = pow(rightStickAxisX, rightJoystickCurve)
		elif rightStickAxisX < 0.0:
			rightStickAxisX = -(pow(abs(rightStickAxisX), rightJoystickCurve))
		if rightStickAxisY > 0.0:
			rightStickAxisY = pow(rightStickAxisY, rightJoystickCurve)
		elif rightStickAxisY < 0.0:
			rightStickAxisY = -(pow(abs(rightStickAxisY), rightJoystickCurve))
		rightStickVector = Vector2(rightStickAxisX, rightStickAxisY)
		rightStickVector = rightStickVector * (rightJoystickSensitivity / 100.0) * RIGHT_JOYSTICK_DPI * delta
		get_viewport().warp_mouse(get_viewport().get_mouse_position() + rightStickVector)
	else:
		rightStickVector = Vector2.ZERO

#                                     *
#                                     *
###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################
#                                     *
#                                     *

func _on_joy_connection_changed(device_id, connected):
	if connected:
		joypadInUse = true
		self.set_physics_process(true)
#		print("Controller now connected.")
#		BusForSignals.emit_signal("joypad_connected")
	else:
		joypadInUse = false
		self.set_physics_process(false)
#		print("Controller now disconnected.")
#		BusForSignals.emit_signal("joypad_disconnected")
