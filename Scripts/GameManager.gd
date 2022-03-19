extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var levelDataDict


var timeDict
var worldNameArray = ["World 0","World 1"]

var levelUI
var endLevelUI
var player
var currentLevel
var waitingForLoad = true;
var endOfLevel = false
var readyToPlay = false

var bronzeMedal = load("res://Sprites/BronzeMedal.png")
var silverMedal = load("res://Sprites/SilverMedal.png")
var goldMedal = load("res://Sprites/GoldMedal.png")

var checkpoint = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	initGameManager()

func _process(delta):
	if waitingForLoad && levelUI != null && endLevelUI != null && player != null:
		initLevel()
		waitingForLoad = false
		readyToPlay = true
	
	if Input.is_action_just_pressed("jump") && currentLevel.level_name != "Menu":
		print("action jump ui")
		if endOfLevel:
			goToNextLevel()
		elif readyToPlay:
			startLevel()
			readyToPlay = false




func getWorldNumber(name):
	return name.substr(name.length()-3,1)


func setLevel(level):
	currentLevel = level

func endLevel():
	endOfLevel = true
	player.get_parent().remove_child(player)
	var finalTime = levelUI.stopTime()
	levelUI.visible = false
	endLevelUI.visible = true
	
	#Set times and medals
	#endLevelUI.setValues(transformTime(finalTime), transformTime(timeDict[currentLevel.level_name]))
	if finalTime < timeDict[currentLevel.level_name] or timeDict[currentLevel.level_name] == 0:
		timeDict[currentLevel.level_name] = finalTime
	
	endLevelUI.setEndLevelUI(finalTime,
	 timeDict[currentLevel.level_name],
	 levelDataDict[currentLevel.level_name]["medal"],
	 currentLevel.level_name,
	 levelDataDict[currentLevel.level_name]["name"])
	
	saveGame()



func transformTime(t):
	var minutes = int(t / 60 / 1000)
	var seconds = int(t / 1000) % 60
	var miliseconds = int(t) % 1000
	var time = ("%02d" % minutes) + (":%02d" % seconds) + (":%03d" % miliseconds)
	return time

func getNextLevel(level_name):
	var levelName = levelDataDict[level_name]["nextLevel"]
	return levelName


func goToNextLevel():

	levelUI = null
	endLevelUI = null
	endOfLevel = false
	waitingForLoad = true
	currentLevel.emitSignalNextLevel()

func reset():
	currentLevel.emitSignalLevel()


func mainMenu():
	#ACTIONS TO DO
	currentLevel.emitSignalMenu()
	
func saveGame():
	var save_game = File.new()
	save_game.open("res://savegame.save", File.WRITE)
	save_game.store_line(to_json(timeDict))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("res://savegame.save"):
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("res://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		timeDict = parse_json(save_game.get_line())

	save_game.close()
	
	
func load_level_data():
	var data = File.new()
	if not data.file_exists("res://data_level_medal.json"):
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	data.open("res://data_level_medal.json", File.READ)
	var json = data.get_as_text()
	levelDataDict = JSON.parse(json).result


	data.close()


	#player.setProcess(true)

func initLevel():
	
	levelUI.visible = false
	endLevelUI.visible = true
	
	endLevelUI.setStartLevelUI(timeDict[currentLevel.level_name],
	 levelDataDict[currentLevel.level_name]["medal"],
	 currentLevel.level_name,
	 levelDataDict[currentLevel.level_name]["name"])
	#endLevelUI.setMedals(0, timeDict[levelName], levelName)
	#playFadeOutAnimation()
	


func startLevel():
	levelUI.visible = true
	endLevelUI.visible = false
	var t = wait(0.5)
	yield(t, "timeout")
	player.particleCircle()
	t = wait(0.25)
	yield(t, "timeout")
	player.setProcess(true)
	t.queue_free()
	
func wait(value):
	var t = Timer.new()
	t.set_wait_time(value)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	return t

func initGameManager():
	load_game()
	load_level_data()

func getLevelName(levelNumber):
	return levelDataDict[levelNumber]["name"]

func getMedal(time, level):
	if time == 0:
		return null
	elif int(levelDataDict[level]["medal"][3]) > time:
		return goldMedal
	elif int(levelDataDict[level]["medal"][2]) > time:
		return goldMedal
	elif int(levelDataDict[level]["medal"][1]) > time:
		return silverMedal
	elif int(levelDataDict[level]["medal"][0]) > time:
		return bronzeMedal
	else:
		return null

func matchMedal(medal, medalSprite):
	match medal:
		0:
			medalSprite.texture = null
		1:
			medalSprite.texture = bronzeMedal
		2:
			medalSprite.texture = silverMedal
		3:
			medalSprite.texture = goldMedal
		4:
			medalSprite.texture = goldMedal
			
func matchWorldName(worldNumber):
	
	if worldNumber <= worldNameArray.size()-1 && worldNumber > 0:
		print(worldNameArray[worldNumber])
		return worldNameArray[worldNumber]
	else:
		return worldNameArray[0]
