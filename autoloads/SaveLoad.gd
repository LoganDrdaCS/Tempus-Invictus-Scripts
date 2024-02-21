extends Node

# STILL NEEDS A LOOKTHROUGH




# HERE IS HOW TO USE IT:
# print(SaveLoad.levelSpecificData.LevelTest1.TimeRecord)
# print(SaveLoad.globalData.Sensitivity)

# USE THIS FOR THE EXPORT, AND MAKE SURE YOU HAVE THE RIGHT GLES VERSION ON:
#const SAVE_FILE = "user://TempusInvictusSaveFileA4.save" ##### for export
const SAVE_FILE = "res://temporary/SaveData/SavedFile.save"  ### for non-export


var levelSpecificData = {}
var globalData = {}

# parent dictionary which will hold the other dictionaries above and be saved:
var savedData = {}

func _ready() -> void:
	load_data()

func save_data():
	savedData = {
		"GlobalData" : globalData, 
		"LevelSpecificData" : levelSpecificData
		}
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_var(savedData)
	file.close()

func load_data():
	var file = File.new()
	if not file.file_exists(SAVE_FILE):
		savedData = create_new_save()
		file.open(SAVE_FILE, File.WRITE)
		file.store_var(savedData)
		file.close()
	file.open(SAVE_FILE, File.READ)
	savedData = file.get_var()
	globalData = savedData.GlobalData
	levelSpecificData = savedData.LevelSpecificData
	file.close()

func create_new_save() -> Dictionary:
	var startingLevelSpecificData = {
		# PRE Levels during level design:
		"PreLevel_1_1" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 0.57, "GoldTime" : 0.75, \
			"SilverTime" : 3.7, "BronzeTime": 4.0},
		"PreLevel_1_2" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 0.60, "GoldTime" : 1.2, \
			"SilverTime" : 3.9, "BronzeTime": 5.0},
		"PreLevel_1_3" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_1_4" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_1_5" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_1_6" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_1_7" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_1_8" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_1_9" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_2_1" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_2_2" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_2_3" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_2_4" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_2_5" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_2_6" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_2_7" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_2_8" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_2_9" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_3_1" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_3_2" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_3_3" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_3_4" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_3_5" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_3_6" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_3_7" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_3_8" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_3_9" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_4_1" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_4_2" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_4_3" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_4_4" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_4_5" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_4_6" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_4_7" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_4_8" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		"PreLevel_4_9" : {"TimeRecord" : 12345, \
			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
			"SilverTime" : 12.0, "BronzeTime": 14.0},
		# NON-LEVELS:
		"FreezeTutorialNL" : {"TimeRecord" : -1, \
			"StarsEarned" : -1, "MasterStarsEarned" : -1, "MasterTime" : -1, "GoldTime" : -1, \
			"SilverTime" : -1, "BronzeTime": -1, "FirstTime" : false}, #set to true for export exe
		"FlowTutorialNL" : {"TimeRecord" : -1, \
			"StarsEarned" : -1, "MasterStarsEarned" : -1, "MasterTime" : -1, "GoldTime" : -1, \
			"SilverTime" : -1, "BronzeTime": -1},
		"For_Level_Screenshots" : {"TimeRecord" : -1, \
			"StarsEarned" : -1, "MasterStarsEarned" : -1, "MasterTime" : -1, "GoldTime" : -1, \
			"SilverTime" : -1, "BronzeTime": -1},
		"Test_Environment" : {"TimeRecord" : -1, \
			"StarsEarned" : -1, "MasterStarsEarned" : -1, "MasterTime" : -1, "GoldTime" : -1, \
			"SilverTime" : -1, "BronzeTime": -1},
		"PracticeRangeFlowNL" : {"TimeRecord" : -1, \
			"StarsEarned" : -1, "MasterStarsEarned" : -1, "MasterTime" : -1, "GoldTime" : -1, \
			"SilverTime" : -1, "BronzeTime": -1},
		"PracticeRangeFreezeNL" : {"TimeRecord" : -1, \
			"StarsEarned" : -1, "MasterStarsEarned" : -1, "MasterTime" : -1, "GoldTime" : -1, \
			"SilverTime" : -1, "BronzeTime": -1},
		# CAMPAIGN LEVELS:
#		"Level_1_1" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 0.3, "GoldTime" : 1.0, \
#			"SilverTime" : 3.5, "BronzeTime": 6.0}, #done
#		"Level_1_2" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_1_3" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_1_4" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_1_5" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_1_6" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_1_7" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_1_8" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 2.4, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_1_9" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_2_1" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_2_2" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_2_3" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_2_4" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_2_5" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_2_6" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_2_7" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_2_8" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_2_9" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_3_1" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_3_2" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_3_3" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_3_4" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_3_5" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_3_6" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_3_7" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_3_8" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_3_9" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_4_1" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_4_2" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_4_3" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_4_4" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_4_5" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_4_6" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_4_7" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_4_8" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
#		"Level_4_9" : {"TimeRecord" : 12345, \
#			"StarsEarned" : 0, "MasterStarsEarned" : 0, "MasterTime" : 7.25, "GoldTime" : 9.0, \
#			"SilverTime" : 12.0, "BronzeTime": 14.0},
			
#		# TEST QUICKPLAY LEVELS:
#		"TESTLEVEL" : {"Unlocked" : true, "TimeRecord" : -1, \
#			"StarsEarned" : 0, "PlayerColor": null},
#		"LevelTest1" : {"Unlocked" : true, "TimeRecord" : 1.817, \
#			"StarsEarned" : 3, "PlayerColor": null},
#		"LevelTest2" : {"Unlocked" : true, "TimeRecord" : 2.183, \
#			"StarsEarned" : 3, "PlayerColor": null},
#		"LevelTest3" : {"Unlocked" : true, "TimeRecord" : 12345.367, \
#			"StarsEarned" : 3, "PlayerColor": null},
#		"LevelTest4" : {"Unlocked" : true, "TimeRecord" : 12345.600, \
#			"StarsEarned" : 3, "PlayerColor": null},
#		"LevelTest5" : {"Unlocked" : true, "TimeRecord" : 3.883, \
#			"StarsEarned" : 3, "PlayerColor": null},
#		"LevelTest6" : {"Unlocked" : true, "TimeRecord" : 12345.717, \
#			"StarsEarned" : 2, "PlayerColor": null},
#		"LevelTest7" : {"Unlocked" : true, "TimeRecord" : 12345.933, \
#			"StarsEarned" : 2, "PlayerColor": null},
#		"LevelTest8" : {"Unlocked" : true, "TimeRecord" : 355.555, \
#			"StarsEarned" : 0, "PlayerColor": null}
	}
	var startingGlobalData = {
		"TotalStarsEarned" : 0,
		"TotalMasterStarsEarned" : 0,
		"ExpertLevelsUnlocked" : false,
#		"Sensitivity" : 50.0,
		"GlobalVolume" : 0.5,
		"SFXVolume" : 1,
		"UISFXVolume" : 1,
		"MusicVolume" : 0.5,
		"InputMapping" : "Default"
	}
	var startingSaveData = {
		"GlobalData" : startingGlobalData,
		"LevelSpecificData" : startingLevelSpecificData
		}
	return startingSaveData
