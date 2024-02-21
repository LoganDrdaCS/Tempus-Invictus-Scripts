extends Node

# STILL NEEDS A LOOKTHROUGH

var bus = "Music"

var songList = [
	"res://audio/music/Amaransu.mp3", 
	"res://audio/music/Awakening.mp3", 
	"res://audio/music/BestTime.mp3", 
	"res://audio/music/ChillAbstract.mp3", 
	"res://audio/music/Countdown.mp3", 
	"res://audio/music/DoItYourself.mp3", 
	"res://audio/music/Dragonfly.mp3", 
	"res://audio/music/Emerald.mp3", 
	"res://audio/music/IntoTheNight.mp3", 
	"res://audio/music/JazzyAbstract.mp3", 
	"res://audio/music/JoinUs.mp3", 
	"res://audio/music/LofiStudy.mp3", 
	"res://audio/music/MysteriousWorld.mp3", 
	"res://audio/music/Nessa.mp3", 
	"res://audio/music/Review.mp3", 
	"res://audio/music/SlowTrap.mp3", 
	"res://audio/music/SpiralGalaxy.mp3", 
	"res://audio/music/TensePiano.mp3", 
	"res://audio/music/TheDestroyer.mp3", 
	"res://audio/music/Whip.mp3"
]

var numberOfSongs : int
var currentSongNumber : int = 1

onready var musicPlayer = $AudioStreamPlayer
onready var timer = $Timer

func _ready():
	BusForSignals.connect("next_song", self, "_next_song")
	# create a randomized order of the songs to play for this run
	randomize()
	songList.shuffle()
	numberOfSongs = len(songList)

func _on_AudioStreamPlayer_finished() -> void:
	currentSongNumber += 1
	if currentSongNumber > numberOfSongs:
		currentSongNumber = 1
		_ready()
	musicPlayer.stream = load(songList[currentSongNumber - 1])
	musicPlayer.play()
	print(songList[currentSongNumber - 1])

func _on_Timer_timeout() -> void:
	musicPlayer.stream = load(songList[0])
	musicPlayer.play()
	print(songList[0])

func _next_song():
	musicPlayer.emit_signal("finished")
