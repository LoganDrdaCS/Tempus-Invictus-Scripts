extends Control

onready var startingTimer = $StartingTimer
onready var timer1 = $Timer
onready var timer2 = $Timer2
onready var timer3 = $Timer3
onready var timer4 = $Timer4
onready var timer5 = $Timer5
onready var timer6 = $Timer6
onready var timer7 = $Timer7
onready var timer8 = $Timer8
onready var timer9 = $Timer9
onready var timer10 = $Timer10
onready var timer11 = $Timer11

onready var label2 = $Panel/Label2
onready var label3 = $Panel/Label3
onready var label4 = $Panel/Label4
onready var label5 = $Panel/Label5
onready var label6 = $Panel/Label6
onready var label7 = $Panel/Label7
onready var label8 = $Panel/Label8

onready var whiteStar = $Panel/White
onready var bronzeStar = $Panel/Bronze
onready var silverStar = $Panel/Silver
onready var goldStar = $Panel/Gold
onready var masterStar = $Panel/Master

onready var stream1 = $AudioStreamPlayer
onready var stream2 = $AudioStreamPlayer2
onready var stream3 = $AudioStreamPlayer3
onready var stream4 = $AudioStreamPlayer4
onready var stream5 = $AudioStreamPlayer5

# external references
onready var player = CoreFunctions.get_player()
onready var currentLevelName = CoreFunctions.get_main_node().name
onready var gameTimer = self.get_parent().get_node("GameTimer")
onready var pauseMenu = CoreFunctions.get_main_node().get_node("HUD").get_node("PauseMenu")

var time : float
var starsEarned : int
var recordStars : int
var masterStarsEarned : int
var masterStarsAlreadyEarned : int
var addedGlobalStars : int
var addedGlobalMasterStars : int
var noMasterTimeForThisLevel : bool = false

var bronzeTime
var silverTime
var goldTime
var masterTime
var bronzeTimeString
var silverTimeString
var goldTimeString
var masterTimeString
var newHighScore : bool = false

var label2initial : String
var label3initial : String
var label4initial : String
var label5initial : String
var label6initial : String
var label7initial : String

func _ready() -> void:
	self.rect_position = Vector2(0, 0)
	if not "NL" in currentLevelName:
		if not SaveLoad.levelSpecificData[currentLevelName].StarsEarned == -1:
			BusForSignals.connect("player_has_paused", self, "_paused")
			BusForSignals.connect("player_has_unpaused", self, "_unpaused")
			BusForSignals.connect("all_enemies_killed", self, "_all_enemies_killed")
			BusForSignals.connect("restart_initiated", self, "_restart")
			BusForSignals.connect("new_high_score", self, "_new_high_score")
			BusForSignals.connect("not_new_high_score", self, "_not_new_high_score")
			label2initial = label2.text
			label3initial = label3.text
			label4initial = label4.text
			label5initial = label5.text
			label6initial = label6.text
			label7initial = label7.text
			bronzeTimeString = ""
			silverTimeString = ""
			goldTimeString = ""
			masterTimeString = ""
			starsEarned = 0
			load_stars()
		self.visible = false

func _new_high_score() -> void:
	newHighScore = true
	if not "NL" in currentLevelName:
		time = gameTimer.time
		if time < bronzeTime:
			starsEarned += 1
		if time < silverTime:
			starsEarned += 1
		if time < goldTime:
			starsEarned += 1
		if time < masterTime:
			masterStarsEarned = 1
		if starsEarned > recordStars:
			addedGlobalStars = starsEarned - recordStars
			SaveLoad.globalData.TotalStarsEarned += addedGlobalStars
			SaveLoad.levelSpecificData[currentLevelName].StarsEarned = starsEarned
			SaveLoad.save_data()
		if masterStarsAlreadyEarned == 0 and masterStarsEarned == 1:
			SaveLoad.globalData.TotalMasterStarsEarned += 1
			SaveLoad.levelSpecificData[currentLevelName].MasterStarsEarned += 1
			SaveLoad.save_data()
		startingTimer.start(1.50)
		timer10.start(0.95)

func _not_new_high_score() -> void:
	if not "NL" in currentLevelName:
		time = gameTimer.time
		if time < bronzeTime:
			starsEarned += 1
		if time < silverTime:
			starsEarned += 1
		if time < goldTime:
			starsEarned += 1
		if time < masterTime:
			masterStarsEarned = 1
		if starsEarned > recordStars:
			addedGlobalStars = starsEarned - recordStars
			SaveLoad.globalData.TotalStarsEarned += addedGlobalStars
			SaveLoad.levelSpecificData[currentLevelName].StarsEarned = starsEarned
			SaveLoad.save_data()
		if masterStarsAlreadyEarned == 0 and masterStarsEarned == 1:
			SaveLoad.globalData.TotalMasterStarsEarned += 1
			SaveLoad.levelSpecificData[currentLevelName].MasterStarsEarned += 1
			SaveLoad.save_data()
	self.rect_position = Vector2(0, -150)
	timer11.start(1.50)
	timer10.start(.70)


func _all_enemies_killed() -> void:
	pass
#	if not "NL" in currentLevelName:
#		time = gameTimer.time
#		if time < bronzeTime:
#			starsEarned += 1
#		if time < silverTime:
#			starsEarned += 1
#		if time < goldTime:
#			starsEarned += 1
#		if time < masterTime:
#			masterStarsEarned = 1
#		if starsEarned > recordStars:
#			addedGlobalStars = starsEarned - recordStars
#			SaveLoad.globalData.TotalStarsEarned += addedGlobalStars
#			SaveLoad.levelSpecificData[currentLevelName].StarsEarned = starsEarned
#			SaveLoad.save_data()
#		if masterStarsAlreadyEarned == 0 and masterStarsEarned == 1:
#			SaveLoad.globalData.TotalMasterStarsEarned += 1
#			SaveLoad.levelSpecificData[currentLevelName].MasterStarsEarned += 1
#			SaveLoad.save_data()
#	self.rect_position = Vector2(0, -150)
#	timer11.start(1.50)
#	timer10.start(.70)

func _on_StartingTimer_timeout() -> void:
	self.visible = true
	timer1.start(1.50)
	label2.text = label2.text + gameTimer.timeLabel.text

func _on_Timer_timeout() -> void:
	stream2.play()
	timer2.start(1.00)
	label3.visible = true
	label3.text = label3.text + bronzeTimeString

func _on_Timer2_timeout() -> void:
	if time < bronzeTime + 0.0009:
		stream3.play()
		timer3.start(1.50)
		whiteStar.visible = false
		bronzeStar.visible = true
	else:
		timer3.start(0.1)

func _on_Timer3_timeout() -> void:
	stream2.pitch_scale = 0.75
	stream2.play()
	timer4.start(1.00)
	label4.visible = true
	label4.text = label4.text + silverTimeString

func _on_Timer4_timeout() -> void:
	if time < silverTime + 0.0009:
		stream3.pitch_scale = 1.1
		stream3.play()
		timer5.start(1.50)
		bronzeStar.visible = false
		silverStar.visible = true
	else:
		timer5.start(0.1)

func _on_Timer5_timeout() -> void:
	stream2.pitch_scale = 0.85
	stream2.play()
	timer6.start(1.00)
	label5.visible = true
	label5.text = label5.text + goldTimeString

func _on_Timer6_timeout() -> void:
	if time < goldTime + 0.0009:
		stream3.pitch_scale = 1.2
		stream3.play()
		silverStar.visible = false
		goldStar.visible = true
		timer7.start(1.50)
	else:
		timer7.start(0.1)

func _on_Timer7_timeout() -> void:
	stream2.pitch_scale = 0.95
	stream2.play()
	timer8.start(1.00)
	label6.visible = true
	label6.text = label6.text + masterTimeString

func _on_Timer8_timeout() -> void:
	if noMasterTimeForThisLevel == true:
		timer9.start(0.1)
	else:
		if time < masterTime + 0.0009:
			stream3.pitch_scale = 1.3
			stream3.play()
			stream5.play()
			timer9.start(2.25)
			goldStar.visible = false
			masterStar.visible = true
		else:
			timer9.start(0.1)

func _on_Timer9_timeout() -> void:
	stream4.play()
	label7.text = "Your rating for this run: " + String(starsEarned) + " stars"
	label7.visible = true
	label8.visible = true

func _restart() -> void:
	self.visible = false
	self.rect_position = Vector2(0, 0)
	startingTimer.stop()
	timer1.stop()
	timer2.stop()
	timer3.stop()
	timer4.stop()
	timer5.stop()
	timer6.stop()
	timer7.stop()
	timer8.stop()
	timer9.stop()
	timer10.stop()
	timer11.stop()
	label3.visible = false
	label4.visible = false
	label5.visible = false
	label6.visible = false
	label7.visible = false
	label8.visible = false
	masterStar.visible = false
	goldStar.visible = false
	silverStar.visible = false
	bronzeStar.visible = false
	whiteStar.visible = true
	label2.text = label2initial
	label3.text = label3initial
	label4.text = label4initial
	label5.text = label5initial
	label6.text = label6initial
	label7.text = label7initial
	bronzeTimeString = ""
	silverTimeString = ""
	goldTimeString = ""
	masterTimeString = ""
	starsEarned = 0
	masterStarsEarned = 0
	stream1.stop()
	stream2.stop()
	stream3.stop()
	stream4.stop()
	stream5.stop()
	stream2.pitch_scale = 0.65
	stream3.pitch_scale = 1.0
	newHighScore = false
	load_stars()
	
func load_stars():
	if SaveLoad.levelSpecificData.has(currentLevelName) and not "Test" in currentLevelName:
		bronzeTime = SaveLoad.levelSpecificData[currentLevelName].BronzeTime
		silverTime = SaveLoad.levelSpecificData[currentLevelName].SilverTime
		goldTime = SaveLoad.levelSpecificData[currentLevelName].GoldTime
		masterTime = SaveLoad.levelSpecificData[currentLevelName].MasterTime
		var bms = int(round(fmod(bronzeTime, 1) * 1000))
		var bseconds = fmod(bronzeTime, 60)
		var bminutes = fmod(bronzeTime, 3600) / 60
		var bstr = "%01d:%02d:%03d" % [bminutes, bseconds, bms]
		var sms = int(round(fmod(silverTime, 1) * 1000))
		var sseconds = fmod(silverTime, 60)
		var sminutes = fmod(silverTime, 3600) / 60
		var sstr = "%01d:%02d:%03d" % [sminutes, sseconds, sms]
		var gms = int(round(fmod(goldTime, 1) * 1000))
		var gseconds = fmod(goldTime, 60)
		var gminutes = fmod(goldTime, 3600) / 60
		var gstr = "%01d:%02d:%03d" % [gminutes, gseconds, gms]
		var mstr : String
		if masterTime == -1:
			mstr = "N/A"
			noMasterTimeForThisLevel = true
		else:
			var mms = int(round(fmod(masterTime, 1) * 1000))
			var mseconds = fmod(masterTime, 60)
			var mminutes = fmod(masterTime, 3600) / 60
			mstr = "%01d:%02d:%03d" % [mminutes, mseconds, mms]
		bronzeTimeString = bstr
		silverTimeString = sstr
		goldTimeString = gstr
		masterTimeString = mstr
		recordStars = SaveLoad.levelSpecificData[currentLevelName].StarsEarned
		masterStarsAlreadyEarned = SaveLoad.levelSpecificData[currentLevelName].MasterStarsEarned

func _on_Timer10_timeout() -> void:
	stream1.play()

func _paused() -> void:
#	print('paused')
	timer1.paused = true
	timer2.paused = true
	timer3.paused = true
	timer4.paused = true
	timer5.paused = true
	timer6.paused = true
	timer7.paused = true
	timer8.paused = true
	timer9.paused = true
	timer10.paused = true
	timer11.paused = true
	startingTimer.paused = true

func _unpaused() -> void:
#	print('unpaused')
	timer1.paused = false
	timer2.paused = false
	timer3.paused = false
	timer4.paused = false
	timer5.paused = false
	timer6.paused = false
	timer7.paused = false
	timer8.paused = false
	timer9.paused = false
	timer10.paused = false
	timer11.paused = false
	startingTimer.paused = false


func _on_Timer11_timeout() -> void:
	self.visible = true
	label2.text = label2.text + gameTimer.timeLabel.text
	label3.visible = true
	label3.text = label3.text + bronzeTimeString
	if time < bronzeTime + 0.0009:
#		stream3.play()
		whiteStar.visible = false
		bronzeStar.visible = true
	stream2.pitch_scale = 0.75
#	stream2.play()
	label4.visible = true
	label4.text = label4.text + silverTimeString
	if time < silverTime + 0.0009:
		stream3.pitch_scale = 1.1
#		stream3.play()
		bronzeStar.visible = false
		silverStar.visible = true
	stream2.pitch_scale = 0.85
#	stream2.play()
	label5.visible = true
	label5.text = label5.text + goldTimeString
	if time < goldTime + 0.0009:
		stream3.pitch_scale = 1.2
#		stream3.play()
		silverStar.visible = false
		goldStar.visible = true
	stream2.pitch_scale = 0.95
#	stream2.play()
	label6.visible = true
	label6.text = label6.text + masterTimeString
	if noMasterTimeForThisLevel == true:
		pass
	else:
		if time < masterTime + 0.0009:
			stream3.pitch_scale = 1.3
#			stream3.play()
#			stream5.play()
			goldStar.visible = false
			masterStar.visible = true
#	stream4.play()
	label7.text = "Your rating for this run: " + String(starsEarned) + " stars"
	label7.visible = true
	label8.visible = true

