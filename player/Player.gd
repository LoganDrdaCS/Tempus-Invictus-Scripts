extends KinematicBody2D

const bombPathway = preload("res://scenes/items/Bomb.tscn")
const bulletDefaultPathway = \
	preload("res://scenes/items/BulletDefault.tscn")
const bulletThornPathway = \
	preload("res://scenes/items/BulletThornBeam.tscn")
const bulletEtherealPathway = \
	preload("res://scenes/items/BulletEthereal.tscn")
const platformPathway = preload("res://scenes/levelDesign/PlatformA.tscn")
const tetherPathway = preload("res://scenes/items/Tether.tscn")

# movement variables
var jumpHeight : float = 380
var jumpHeightMinimum : float = 150
var jumpMax : int = 3
var jumpTimeToDescent : float = 0.275
var jumpTimeToPeak : float = 0.35
var movementSpeed: float = 475 # pixels per second due to delta

# determining gravity and jumps
onready var fallGravity : float = ((-2.0 * jumpHeight) / \
	(jumpTimeToDescent * jumpTimeToDescent)) * -1.0
onready var jumpGravity : float = (2.0 * jumpHeight) / \
	(jumpTimeToPeak * jumpTimeToPeak)
onready var jumpVelocity : float = ((2.0 * jumpHeight) / jumpTimeToPeak) * -1.0
onready var speedAtMinimumHeight : float = -(sqrt(pow(jumpVelocity, 2.0) + \
	(2.0 * jumpGravity * jumpHeightMinimum * -1.0)))
onready var timeAtMinimumHeight : float = \
	(speedAtMinimumHeight - jumpVelocity) / jumpGravity

# exported variables for color, mode, and modifiers
export var bulletsDefaultOwnedInitial : int = 123
export(String, "Freeze", "Flow", "Neither") var mode : String = "Freeze"
export var playerColor : Color = Color(0, 0, 0, 1)
enum modifiersExportList {
	noBurst, # 0
	noStasis, # 1
	noJump, # 2
	noTether, # 3
	noToggle, # 4
	reducedGravity # 5
	upsideDown # 6
}
export(Array, modifiersExportList) var modifiers : Array = []

# internal references
onready var aimRotator = $AimRotator
onready var bulletDefaultOverlay = $AimRotator/Reticle/BulletDefaultOverlay
onready var bulletThornOverlay = $AimRotator/Reticle/BulletThornOverlay
onready var bulletEtherealOverlay = $AimRotator/Reticle/BulletEtherealOverlay
onready var burstCooldownTimer = $Timers/BurstCooldown
onready var burstDurationTimer = $Timers/BurstDuration
onready var camera = $Camera2D
onready var collisionShape = $CollisionShape2D
onready var stasisCooldownTimer = $Timers/StasisCooldown
onready var stasisDurationTimer = $Timers/StasisDuration
onready var jumpMinimumHeightTimer = $Timers/JumpMinimumHeightTimer
onready var light2D = $Light2D
onready var potionPlatformOverlay = $AimRotator/Reticle/PotionPlatformOverlay
onready var primaryAttackCooldownTimer = $Timers/PrimaryAttackCooldown
onready var sprite = $Sprite

onready var SFX := $SoundEffects
onready var firstJumpSound: AudioStreamPlayer = $SoundEffects/FirstJump
onready var secondJumpSound: AudioStreamPlayer = $SoundEffects/SecondJump
onready var thirdJumpSound: AudioStreamPlayer = $SoundEffects/ThirdJump
onready var landingSound: AudioStreamPlayer = $SoundEffects/Landing
onready var bulletDefaultSound: AudioStreamPlayer = $SoundEffects/BulletDefault
onready var bulletEtherealSound: AudioStreamPlayer = $SoundEffects/BulletEthereal
onready var teleportToTetherSound: AudioStreamPlayer = $SoundEffects/TeleportToTether
onready var placeTetherSound: AudioStreamPlayer = $SoundEffects/PlaceTether
onready var placeBombSound: AudioStreamPlayer = $SoundEffects/PlaceFrozenBomb
onready var itemPickupSound: AudioStreamPlayer = $SoundEffects/ItemPickup
onready var emptyGunSound: AudioStreamPlayer = $SoundEffects/EmptyGun
onready var burstStartSound: AudioStreamPlayer = $SoundEffects/BurstStart
onready var stasisStartSound: AudioStreamPlayer = $SoundEffects/StasisStart
onready var shootBulletThornBeamSound: AudioStreamPlayer = $SoundEffects/ShootBulletThornBeam
onready var burstEndSound: AudioStreamPlayer = $SoundEffects/BurstEnd
onready var stasisEndSound: AudioStreamPlayer = $SoundEffects/StasisEnd
onready var platformPlacedSound: AudioStreamPlayer2D = $SoundEffects/PlatformPlaced
onready var lastBulletSound: AudioStreamPlayer = $SoundEffects/LastBullet



onready var tweenMusic = $MusicTween
#export var musicStasisFadeToDB : float = -6.0
#export var musicBurstFadeToDB: float = -1.5
#export var musicFadeTime : float = 0.2
onready var musicPlayer = MusicManager.musicPlayer

# external object references

onready var gameTimer = \
	CoreFunctions.get_main_node().get_node("HUD").get_node_or_null("GameTimer")
onready var tetherLine = CoreFunctions.get_main_node().get_node("Managers").get_node_or_null\
	("TetherManager").get_node_or_null("TetherLine")
onready var enemyManager = \
	CoreFunctions.get_main_node().get_node("Managers").get_node_or_null("EnemyManager")
onready var fullScreenCamera = \
	CoreFunctions.get_main_node().get_node_or_null("FullScreenCamera")
onready var HUD = CoreFunctions.get_main_node().get_node_or_null("HUD")
onready var tetherManager = \
	CoreFunctions.get_main_node().get_node("Managers").get_node_or_null("TetherManager")
onready var hourglass = null
onready var itemManager = \
	CoreFunctions.get_main_node().get_node("Managers").get_node_or_null("ItemManager")
onready var levelDesign = CoreFunctions.get_main_node().get_node_or_null("LevelDesign")
onready var projectileManager = \
	CoreFunctions.get_main_node().get_node("Managers").get_node_or_null("ProjectileManager")
onready var ammoLabel = \
	CoreFunctions.get_main_node().get_node("HUD").get_node_or_null("AmmoLabel")
onready var currentLevelName = CoreFunctions.get_main_node().name

var allEnemiesKilled : bool = false
var bombsOwned : int = 0
var bulletsDefaultOwned : int
var bulletsThornOwned : int = 0
var bulletsEtherealOwned : int = 0
var burst = false setget set_burst
var burstQueued : bool = false
var burstTime1 : float
var burstTime2 : float
var direction : int = 1
#var frame : int = 0
var stasis = false setget set_stasis
var stasisQueued : bool = false
var globalVolume : float
var horizontalThrow : float = 0.0
var initialPosition : Vector2
var inputCount : int = 0
var itemsOwnedOrder : Array = []
var jumpCounter : int = 0
var jumping : bool = false
var onGround : bool = false
var onSteepSlope : bool = false
var pauseForCameraAdjustment : bool = false
var potionsPlatformOwned : int = 0
var preStasisVelocity : Vector2
var snapVector : Vector2
var tetherCount : int = 0
var tetherCountMax : int = 2
#var tetherForGhost : bool = false
var tetherPosition1 : Vector2
var tetherPosition2 : Vector2
var tetherSet : bool = false
var velocity : Vector2 = Vector2.ZERO

# modifier variables
var canBomb := true
var canBurst := true
var canStasis := true
var canJump := true
var canMove := true
var canPause := true
#var canPickup := true
var canQuickRestart := true
var canShoot := true
var canTether := true
var canToggleFullscreen := true

var reducedGravity := false
var upsideDown := false
var bombOverridden := false
var burstOverridden := false
var cameraOverridden : bool = false
var stasisOverridden := false
var jumpOverridden := false
var moveOverridden := false
var pauseOverridden := false
var quickRestartOverridden := false
var shootOverridden := false
var tetherOverridden := false
var toggleFullscreenOverridden := false

# controller support
var leftStickAxisX : float
var leftStickAxisY : float
var leftJoystickDeadzone = ControllerSupport.leftJoystickDeadzone
#var leftJoystickCurve = ControllerSupport.leftJoystickCurve

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
#	if not HUD == null:
#		gameTimer = \
#			CoreFunctions.get_main_node().get_node("HUD").get_node_or_null("GameTimer")
#	if not tetherManager == null:
#		tetherLine = CoreFunctions.get_main_node().get_node_or_null\
#			("TetherManager").get_node_or_null("TetherLine")
	for item in modifiers:
		match item:
			0:
				canBurst = false
				burstOverridden = true
			1:
				canStasis = false
				stasisOverridden = true
			2:
				canJump = false
				jumpOverridden = true
			3:
				canTether = false
				tetherOverridden = true
			4:
				toggleFullscreenOverridden = true
				canToggleFullscreen = false
			5:
				reducedGravity = true
				fallGravity = fallGravity / 1.7
				jumpGravity = jumpGravity / 1.7
			6: 
				upsideDown = true
				self.camera.zoom.y = -self.camera.zoom.y
	if mode == "Freeze":
		self.set_collision_mask_bit(2, true)
		hourglass = CoreFunctions.get_main_node().get_node("LevelDesign").get_node_or_null("Hourglass")
	initial_signal_connects()
	initialPosition = self.global_position
	if playerColor == Color(0, 0, 0, 1):
		randomize_color()
	else:
		sprite.modulate = playerColor
		light2D.color = playerColor
	bulletsDefaultOwned = bulletsDefaultOwnedInitial
	if not fullScreenCamera == null:
		if not cameraOverridden and not upsideDown:
			camera.limit_right = fullScreenCamera.levelWidth
			camera.limit_bottom = fullScreenCamera.levelHeight
			camera.force_update_scroll()
			camera.reset_smoothing()
		elif not cameraOverridden and upsideDown:
			camera.limit_right = fullScreenCamera.levelWidth
			camera.limit_bottom = 0
			camera.limit_top = fullScreenCamera.levelHeight
			camera.force_update_scroll()
			camera.reset_smoothing()
	else:
		canToggleFullscreen = false
		camera.limit_right = 1920
		camera.limit_bottom = 1080
		camera.force_update_scroll()
		camera.reset_smoothing()

func _physics_process(delta: float) -> void:
	# quick restart of level at any time
	if Input.is_action_just_pressed("quick_restart") and canQuickRestart:
		CoreFunctions.unpause_tree()
		BusForSignals.emit_signal("restart_initiated")

	if pauseForCameraAdjustment:
		return

	if Input.is_action_just_pressed("toggle_screen") and canToggleFullscreen:
		if camera.current == true:
			fullScreenCamera._instant_zoom()
		elif camera.current == false and cameraOverridden == true:
			fullScreenCamera._instant_zoom()
		else:
			camera.current = true

	if stasis or burst:
		if mode == "Flow":
			self.set_collision_mask_bit(2, true)
		Physics2DServer.set_active(true)
		if stasis:
			burstCooldownTimer.set_paused(true)
		elif burst:
			stasisCooldownTimer.set_paused(true)
	else:
		sprite.is_emitting = false
		if mode == "Flow":
			self.set_collision_mask_bit(2, false)
		burstCooldownTimer.set_paused(false)
		stasisCooldownTimer.set_paused(false)

	# align reticle with mouse
	aimRotator.look_at(get_global_mouse_position())

	# if you run into major slope bugs, try changing is_on_floor to onGround
	if is_on_floor():
		snapVector = -get_floor_normal() * 5.0
	else:
		snapVector = Vector2.ZERO
	
	# finding out when you land from a jump
	if is_on_floor():
		if !onGround:
			onGround = true
			jumpCounter = 0
			if not onSteepSlope:
				landingSound.play()
	elif onGround:
		onGround = false

#	horizontalThrow = Input.get_action_strength("right") \
#		- Input.get_action_strength("left")
#	if horizontalThrow > 0.0:
#		direction = 1
#	elif horizontalThrow < 0.0:
#		direction = -1
#	velocity.x = horizontalThrow * movementSpeed

	if ControllerSupport.joypadInUse == false:
		horizontalThrow = Input.get_action_strength("right") \
			- Input.get_action_strength("left")
		if horizontalThrow > 0.0:
			direction = 1
		elif horizontalThrow < 0.0:
			direction = -1
		velocity.x = horizontalThrow * movementSpeed
	else:
		leftStickAxisX = Input.get_joy_axis(0, JOY_AXIS_0)
		leftStickAxisY = Input.get_joy_axis(0, JOY_AXIS_1)	
		if sqrt(pow(leftStickAxisX, 2) + pow(leftStickAxisY, 2)) > leftJoystickDeadzone:
			if leftStickAxisX > 0:
#				leftStickAxisX = pow(leftStickAxisX, leftJoystickCurve)
				direction = 1
				horizontalThrow = 1
			elif leftStickAxisX < 0:
#				leftStickAxisX = -(pow(abs(leftStickAxisX), leftJoystickCurve))
				direction = -1
				horizontalThrow = -1
		else:
			leftStickAxisX = 0.0
			horizontalThrow = 0
#		velocity.x = leftStickAxisX * movementSpeed
		velocity.x = movementSpeed * horizontalThrow

	# gravity effects; delta multiplied in again to get time^2
	velocity.y += get_gravity_version() * delta
	if onGround:
		velocity.y = clamp(velocity.y, 0, jumpGravity)
	
	if not canMove:
		velocity = Vector2.ZERO

	# primary attack, including item pickups	
	if Input.is_action_just_pressed("attack") \
	and primaryAttackCooldownTimer.is_stopped() and canShoot:
		if itemsOwnedOrder.size() == 0:
			if bulletsDefaultOwned > 0:
				shoot()
			else:
				emptyGunSound.play()
		else:
			if itemsOwnedOrder[-1] == "potionPlatform":
				place_platform()
			elif itemsOwnedOrder[-1] == "bulletEthereal":
				shoot_bullet_ethereal()
				bulletEtherealSound.play()
			elif itemsOwnedOrder[-1] == "bulletThorn":
				shoot_bullet_thorn()

	# burst ability
	if Input.is_action_just_pressed("burst") and canBurst:
		if not stasis and not burst and burstCooldownTimer.is_stopped():
			burstTime1 = gameTimer.time
			activate_burst()
		elif stasis and burstCooldownTimer.is_stopped() and not burstQueued:
			burstQueued = true
			yield(stasisDurationTimer, "timeout")
			activate_burst()
		elif not stasis and not burst and not burstCooldownTimer.is_stopped() and not burstQueued:
			burstQueued = true
			yield(burstCooldownTimer, "timeout")
			burstTime2 = gameTimer.time
			activate_burst()
			if burstTime2 - burstTime1 > (burstCooldownTimer.wait_time + 0.0001):
				gameTimer._change_time_to(burstTime1 + burstCooldownTimer.wait_time)
			yield(get_tree(), "idle_frame")
			burstTime1 = gameTimer.time
			burstTime2 = 0.0
		
	# stasis ability
	if Input.is_action_just_pressed("stasis") and canStasis:
		if not burst and not stasis and stasisCooldownTimer.is_stopped() and not stasisQueued:
			activate_stasis()
		elif burst and stasisCooldownTimer.is_stopped():
			stasisQueued = true
			yield(burstDurationTimer, "timeout")
			activate_stasis()
		elif not stasis and not burst and not stasisCooldownTimer.is_stopped() and not stasisQueued:
			stasisQueued = true
			yield(stasisCooldownTimer, "timeout")
			activate_stasis()

	# tether teleport ability
	if Input.is_action_just_pressed("tether") and canTether:
		if not tetherSet and tetherCount <= tetherCountMax:
			place_tether(self.global_position)
			tetherSet = true
			placeTetherSound.play()
		elif tetherSet and tetherCount <= tetherCountMax:
			teleport_to_tether()
			teleportToTetherSound.play()

	# bomb ability
	if Input.is_action_just_pressed("bomb") and canBomb:
		if bombsOwned > 0:
			activate_bomb()
			if mode == "Flow" and (burst or stasis):
				placeBombSound.play()
			elif mode == "Freeze":
				placeBombSound.play()

	# jumping; remember, the jump doesn't start until move_and_slide_with_snap()
	if Input.is_action_just_pressed("jump") and canJump and not onSteepSlope:
		if jumpCounter == 0:
			jump()
			firstJumpSound.play()
		elif jumpCounter == 1:
			jump_again()
			secondJumpSound.play()
		elif jumpCounter == 2:
			jump_again()
			thirdJumpSound.play()

	if Input.is_action_just_released("jump") and velocity.y < 0.0 and canJump \
	and not onSteepSlope and not reducedGravity:
		if not jumpMinimumHeightTimer.is_stopped():
			$Timer.start(jumpMinimumHeightTimer.time_left); yield($Timer, "timeout")
			if jumpMinimumHeightTimer.is_stopped() and velocity.y < 0.0:
				velocity.y = 0.0
		else:
			velocity.y = 0.0

	onSteepSlope = false

	if is_on_wall() and not is_on_floor():
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision:
				if not abs(collision.normal.x) >= 0.98:
					if collision.normal.x < 0 and velocity.x > 0:
						velocity.x = 0.0
					elif collision.normal.x > 0 and velocity.x < 0:
						velocity.x = 0.0
					onSteepSlope = true
	
	if onSteepSlope:
		velocity.y = fallGravity * delta * 7.5

	if not stasis:
		velocity = move_and_slide_with_snap(
			velocity, Vector2.DOWN, Vector2.UP, true, 
			4, 0.8, false
			)
	else:
		velocity = Vector2.ZERO

	# clamping value for now, just so I don't have to put floors
	position.x = clamp(position.x, 46, fullScreenCamera.levelWidth - 46)
	position.y = clamp(position.y, 46, fullScreenCamera.levelHeight + 100)
	
	jumping = false


#		                              *
#		                              *
###############################################################################
# # # # # # # # # # # # # # # # SEPARATE FUNCTIONS # # # # # # # # # # # # # # 
###############################################################################
#		                              *
#		                              *

func _add_bomb():
	bombsOwned += 1
	itemPickupSound.play()

func _add_bullet_thorn() -> void:
	bulletsThornOwned += 1
	itemsOwnedOrder.append("bulletThorn")
	itemPickupSound.play()
	reticle_checker()

func _add_bullet_ethereal() -> void:
	bulletsEtherealOwned += 1
	itemsOwnedOrder.append("bulletEthereal")
	itemPickupSound.play()
	reticle_checker()

func _add_potion_platform() -> void:
	potionsPlatformOwned += 1
	itemsOwnedOrder.append("potionPlatform")
	itemPickupSound.play()
	reticle_checker()

func activate_bomb() -> void:
	bombsOwned -= 1
	var bomb = bombPathway.instance()
	projectileManager.add_child(bomb)
	bomb.position = self.global_position
	BusForSignals.emit_signal("bomb_activated", bombsOwned)
	bomb._explode()
	end_game_camera_checker()

func activate_burst() -> void:
	burstStartSound.play()
	self.burst = true
	burstDurationTimer.start()
	sprite.is_emitting = true

func activate_stasis() -> void:
	stasisStartSound.play()
	self.stasis = true
	stasisDurationTimer.start()
	preStasisVelocity = velocity

func end_game_camera() -> void:
	if mode == "Freeze":
		if not (fullScreenCamera.screenRatio == 1 and fullScreenCamera.zoomNecessary == 1):
			fullScreenCamera.current = true
			fullScreenCamera.position = self.global_position
			pauseForCameraAdjustment = true
			CoreFunctions.pause_tree()
			stasisDurationTimer.stop()
			stasisCooldownTimer.stop()
			burstDurationTimer.stop()
			burstCooldownTimer.stop()
			fullScreenCamera._begin_zoom()
			yield(fullScreenCamera.zoomOutTimer, "timeout")
			if pauseForCameraAdjustment == true:
				pauseForCameraAdjustment = false
				CoreFunctions.unpause_tree()
			if not moveOverridden:
				canMove = true
			if not jumpOverridden:
				canJump = true
	elif mode == "Flow":
		fullScreenCamera.current = true
		fullScreenCamera.position = self.global_position
		pauseForCameraAdjustment = true
		gameTimer.set_physics_process(false)
		CoreFunctions.pause_tree()
		stasisDurationTimer.set_paused(true)
		stasisCooldownTimer.set_paused(true)
		burstDurationTimer.set_paused(true)
		burstCooldownTimer.set_paused(true)
		fullScreenCamera._begin_zoom()
		yield(fullScreenCamera.zoomOutTimer, "timeout")
		stasisDurationTimer.set_paused(false)
		stasisCooldownTimer.set_paused(false)
		burstDurationTimer.set_paused(false)
		burstCooldownTimer.set_paused(false)
		if pauseForCameraAdjustment == true:
			pauseForCameraAdjustment = false
			if not burstDurationTimer.is_stopped():
				burstDurationTimer.stop()
				burstDurationTimer.emit_signal("timeout")
			if not stasisDurationTimer.is_stopped():
				stasisDurationTimer.stop()
				stasisDurationTimer.emit_signal("timeout")
			CoreFunctions.unpause_tree()
			gameTimer.set_physics_process(true)
#	tweenMusic.stop_all()
#	tweenMusic.remove_all()
#	if musicPlayer.volume_db < 0.0:
#		tweenMusic.interpolate_property(musicPlayer, "volume_db", musicStasisFadeToDB, \
#			0.0, musicFadeTime * 1.5, Tween.TRANS_LINEAR)
#		tweenMusic.start()
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0.0)

func end_game_camera_checker() -> void:
	if mode == "Flow":
		if camera.current == true and not allEnemiesKilled:
			if itemsOwnedOrder.size() == 0 and bulletsDefaultOwned == 0:
				if bombsOwned == 0:
					if not (fullScreenCamera.screensTall == 1 and fullScreenCamera.screensWide == 1):
						end_game_camera()
#						canShoot = false
						canStasis = false
						canBurst = false
						canPause = true
					else:
#						canShoot = false
						canStasis = false
						canBurst = false
						canPause = true
#						tweenMusic.stop_all()
#						tweenMusic.remove_all()
#						if musicPlayer.volume_db < 0.0:
#							tweenMusic.interpolate_property(musicPlayer, "volume_db", musicStasisFadeToDB, \
#								0.0, musicFadeTime * 1.5, Tween.TRANS_LINEAR)
#							tweenMusic.start()
#						AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0.0)


func get_gravity_version() -> float:
	return jumpGravity if velocity.y < 0.0 else fallGravity

func jump() -> void:
	velocity.y = jumpVelocity
	jumpMinimumHeightTimer.start(timeAtMinimumHeight)
	jumpCounter += 1
	jumping = true

func jump_again() -> void:
	velocity.y = jumpVelocity * pow(0.95, jumpCounter)
	jumpMinimumHeightTimer.start(timeAtMinimumHeight * pow(0.95, jumpCounter))
	jumpCounter += 1
	jumping = true

func place_tether(tetherPosition):
	tetherCount += 1
	tetherPosition1 = tetherPosition
	var tether = tetherPathway.instance()
	tetherManager.add_child(tether)
#	CoreFunctions.get_main_node().get_node("Managers").get_node("TetherManager").add_child(tether)
	tether.call_deferred("set", "name", "PlayerTether")
	tether.position = tetherPosition1

func randomize_color() -> void:
	var random = RandomNumberGenerator.new()
	var colorArray = [
		Color(1, 1, 1, 1),
#		Color(0.78, 0.14, 0.69, 1),
		Color(0.3, 0.3, 1, 1),
		Color(0.88, 0.91, 0.13, 1),
		Color(1, 0.68, 0, 1),
#		Color(0.82, 0.15, 0.19, 1),
		Color(0.26, 0.84, 0.17, 1),
	]
	random.randomize()
	var colorSeed : int = random.randi_range(0, colorArray.size() - 1)
	sprite.modulate = colorArray[colorSeed]
	light2D.color = colorArray[colorSeed]
	print(colorArray[colorSeed])

func reticle_checker() -> void:
	if itemsOwnedOrder.size() == 0:
		potionPlatformOverlay.visible = false
		bulletEtherealOverlay. visible = false
		bulletDefaultOverlay.visible = true
		bulletThornOverlay.visible = false
#		if bulletsDefaultOwned == 0:
#			aimRotator.visible = false
	elif itemsOwnedOrder[-1] == "bulletEthereal":
		potionPlatformOverlay.visible = false
		bulletEtherealOverlay. visible = true
		bulletDefaultOverlay.visible = true
		bulletThornOverlay.visible = false
#		aimRotator.visible = true
	elif itemsOwnedOrder[-1] == "potionPlatform":
		potionPlatformOverlay.visible = true
		bulletEtherealOverlay. visible = false
		bulletDefaultOverlay.visible = false
		bulletThornOverlay.visible = false
#		aimRotator.visible = true
	elif itemsOwnedOrder[-1] == "bulletThorn":
		potionPlatformOverlay.visible = false
		bulletEtherealOverlay. visible = false
		bulletDefaultOverlay.visible = false
		bulletThornOverlay.visible = true
#		aimRotator.visible = true

func set_burst(value : bool) -> void:
	burst = value
	if mode == "Flow":
		get_tree().paused = burst
	if burst:
		if mode == "Freeze":
			hourglass.pause_mode = Node.PAUSE_MODE_STOP
		gameTimer.set_physics_process(false)
		burstQueued = false
#		tweenMusic.stop_all()
#		tweenMusic.remove_all()
#		tweenMusic.interpolate_property(musicPlayer, "volume_db", 0.0, \
#			musicBurstFadeToDB, musicFadeTime, Tween.TRANS_LINEAR)
#		tweenMusic.start()
	else:
		if mode == "Freeze":
			hourglass.pause_mode = Node.PAUSE_MODE_PROCESS
		gameTimer.set_physics_process(true)
#		tweenMusic.stop_all()
#		tweenMusic.remove_all()
#		if musicPlayer.volume_db < 0.0:
#			tweenMusic.interpolate_property(musicPlayer, "volume_db", musicPlayer.volume_db, \
#				0.0, musicFadeTime * 1.5, Tween.TRANS_LINEAR)
#			tweenMusic.start()
#		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0.0)

func set_stasis(value : bool) -> void:
	stasis = value
	if mode == "Flow":
		get_tree().paused = stasis
	if stasis:
		if mode == "Freeze":
			hourglass.pause_mode = Node.PAUSE_MODE_STOP
		gameTimer.set_physics_process(false)
		stasisQueued = false
#		tweenMusic.stop_all()
#		tweenMusic.remove_all()
#		tweenMusic.interpolate_property(musicPlayer, "volume_db", 0.0, \
#			musicStasisFadeToDB, musicFadeTime, Tween.TRANS_LINEAR)
#		tweenMusic.start()
	else:
		velocity = preStasisVelocity
		if mode == "Freeze":
			hourglass.pause_mode = Node.PAUSE_MODE_PROCESS
		gameTimer.set_physics_process(true)
#		tweenMusic.stop_all()
#		tweenMusic.remove_all()
#		if musicPlayer.volume_db < 0.0:
#			tweenMusic.interpolate_property(musicPlayer, "volume_db", musicPlayer.volume_db, \
#				0.0, musicFadeTime * 1.5, Tween.TRANS_LINEAR)
#			tweenMusic.start()
#		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0.0)

func set_restart_values() -> void:
#	for player in SFX:
#		player.stop()
	for audioPlayer in SFX.get_children():
		audioPlayer.stop()
	platformPlacedSound.position = Vector2.ZERO
	aimRotator.visible = true
	if mode == "Freeze":
		self.set_collision_mask_bit(2, true)
		self.set_collision_layer_bit(1, true)
#	tweenMusic.stop_all()
#	tweenMusic.remove_all()
	$Timer.stop()
	self.global_position = initialPosition
	self.velocity = Vector2.ZERO
	allEnemiesKilled = false
#	aimRotator.visible = true
	bombsOwned = 0
	bulletEtherealOverlay.visible = false
	bulletThornOverlay.visible = false
	potionPlatformOverlay.visible = false
	bulletsThornOwned = 0
	bulletsEtherealOwned = 0
	burstQueued = false
	if not pauseOverridden:
		canPause = true
	if not moveOverridden:
		canMove = true
	if not shootOverridden:
		canShoot = true
	if not burstOverridden:
		canBurst = true
	if not stasisOverridden:
		canStasis = true
	if not toggleFullscreenOverridden:
		canToggleFullscreen = true
	if not jumpOverridden:
		canJump = true
	if not tetherOverridden:
		canTether = true
	if not bombOverridden:
		canBomb = true
#	canPickup = true
	direction = 1
#	frame = 0
	stasisQueued = false
	inputCount = 0
	itemsOwnedOrder = []
	jumpCounter = 0
	pauseForCameraAdjustment = false
	potionsPlatformOwned = 0
	tetherCount = 0
	tetherSet = false
#	musicPlayer.volume_db = 0.0
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0.0)
	reticle_checker()
	if not stasisDurationTimer.is_stopped():
		stasisDurationTimer.stop()
		stasisDurationTimer.emit_signal("timeout")
		burstDurationTimer.stop()
		burstDurationTimer.emit_signal("timeout")
	elif not burstDurationTimer.is_stopped():
		burstDurationTimer.stop()
		burstDurationTimer.emit_signal("timeout")
		stasisDurationTimer.stop()
		stasisDurationTimer.emit_signal("timeout")
	stasisCooldownTimer.stop()
	burstCooldownTimer.stop()
	if playerColor == Color(0, 0, 0, 1):
		randomize_color()
	bulletsDefaultOwned = bulletsDefaultOwnedInitial
	if tetherManager.has_node("PlayerTether"):
		tetherManager.get_node("PlayerTether").queue_free()
	if not cameraOverridden and not upsideDown:
		camera.limit_right = fullScreenCamera.levelWidth
		camera.limit_bottom = fullScreenCamera.levelHeight
		camera.position = Vector2.ZERO
		camera.drag_margin_h_enabled = false
		camera.force_update_scroll()
		camera.reset_smoothing()
		camera.drag_margin_h_enabled = true
	elif not cameraOverridden and upsideDown:
		camera.limit_right = fullScreenCamera.levelWidth
		camera.limit_bottom = 0
		camera.limit_top = fullScreenCamera.levelHeight
		camera.position = Vector2.ZERO
		camera.drag_margin_h_enabled = false
		camera.force_update_scroll()
		camera.reset_smoothing()
		camera.drag_margin_h_enabled = true
	yield(get_tree(), "idle_frame")
	self.velocity = Vector2.ZERO

func shoot() -> void:
	bulletsDefaultOwned -= 1
	ammoLabel._update()
	if bulletsDefaultOwned == 0:
		lastBulletSound.play()
		emptyGunSound.play()
	bulletDefaultSound.play()
	var bullet = bulletDefaultPathway.instance()
	projectileManager.add_child(bullet)
	bullet.transform = aimRotator.get_node\
		("BulletPosition").global_transform
	end_game_camera_checker()
	primaryAttackCooldownTimer.start()

func shoot_bullet_thorn() -> void:
	bulletsThornOwned -= 1
	ammoLabel._update()
	itemsOwnedOrder.pop_back()
	BusForSignals.emit_signal("bullet_thorn_activated")
	reticle_checker()
	var bullet = bulletThornPathway.instance()
	projectileManager.add_child(bullet)
	bullet.transform = aimRotator.get_node\
		("BulletPosition").global_transform
	end_game_camera_checker()

func shoot_bullet_ethereal() -> void:
	bulletsEtherealOwned -= 1
	ammoLabel._update()
	itemsOwnedOrder.pop_back()
	BusForSignals.emit_signal("bullet_ethereal_activated")
	reticle_checker()
	var bullet = bulletEtherealPathway.instance()
	projectileManager.add_child(bullet)
	bullet.transform = aimRotator.get_node\
		("BulletPosition").global_transform
	bullet._instanced()
	end_game_camera_checker()

func place_platform() -> void:
	var mousePosition = get_global_mouse_position()
	potionsPlatformOwned -= 1
	itemsOwnedOrder.pop_back()
	BusForSignals.emit_signal("potion_platform_activated")
	reticle_checker()
	var platform = platformPathway.instance()
	platformPlacedSound.global_position = mousePosition
	platformPlacedSound.play()
	levelDesign.get_node("Platforms").add_child(platform)
	platform.global_position = mousePosition
	platform._instanced(mousePosition)
	end_game_camera_checker()

func teleport_to_tether():
	CoreFunctions.get_main_node().get_node("Managers").get_node\
		("TetherManager").get_node("PlayerTether").free()
	tetherPosition2 = self.global_position
	velocity = Vector2.ZERO
	self.position = tetherPosition1
	if tetherCount < tetherCountMax:
		place_tether(tetherPosition2)
	elif tetherCount == tetherCountMax:
		tetherCount += 1
		tetherSet = false

#		                              *
#		                              *
###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################
#		                              *
#		                              *

func initial_signal_connects() -> void:
	BusForSignals.connect("bomb_obtained", self, "_add_bomb")
	BusForSignals.connect("bullet_ethereal_obtained", self, "_add_bullet_ethereal")
	BusForSignals.connect("bullet_thorn_obtained", self, "_add_bullet_thorn")
	BusForSignals.connect("all_enemies_killed", self, "_all_enemies_killed")
	BusForSignals.connect("restart_initiated", self, "_restart")
	BusForSignals.connect("potion_platform_obtained", self, "_add_potion_platform")
	BusForSignals.connect("hourglass_contacted", self, "_hourglass_contacted")
	BusForSignals.connect("player_has_begun", self, "_player_has_begun")

func _on_StasisDuration_timeout():
	self.stasis = false
	stasisCooldownTimer.start()

func _on_BurstDuration_timeout():
	self.burst = false
	burstCooldownTimer.start()

func _all_enemies_killed():
	allEnemiesKilled = true
	canPause = true
	aimRotator.visible = false
	canShoot = false

func _restart():
	set_restart_values()

func _player_has_begun() -> void:
	if not cameraOverridden:
		yield(get_tree(), "idle_frame")
		canToggleFullscreen = false
		camera.current = true
		canPause = false

func _hourglass_contacted() -> void:
	self.set_collision_mask_bit(2, false)
	canShoot = false
	canBurst = false
	canStasis = false
	canToggleFullscreen = false
	canTether = false
	canBomb = false
	canPause = true
	burst = false
	stasis = false
	aimRotator.visible = false
	if not cameraOverridden:
		end_game_camera()
	else:
		pass
#		tweenMusic.stop_all()
#		tweenMusic.remove_all()
#		if musicPlayer.volume_db < 0.0:
#			tweenMusic.interpolate_property(musicPlayer, "volume_db", musicStasisFadeToDB, \
#				0.0, musicFadeTime * 1.5, Tween.TRANS_LINEAR)
#			tweenMusic.start()
#		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0.0)
	if tetherManager.has_node("PlayerTether"):
		tetherManager.get_node("PlayerTether").queue_free()

func _jumppad(jumpForce):
	velocity.y = -jumpForce
	velocity = move_and_slide_with_snap(
		velocity, Vector2.DOWN, Vector2.UP, true, 
		4, 0.8, false
		)
	jumpCounter = 1
