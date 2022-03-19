extends Panel

onready var labelLavelName = $VBoxContainer/LevelName

onready var labelTime = $VBoxContainer/HBoxContainer/LabelTime
onready var labelBestTime = $VBoxContainer/HBoxContainer2/LabelBestTime
onready var valueTime = $VBoxContainer/HBoxContainer/ValueTime
onready var valueBestTime = $VBoxContainer/HBoxContainer2/ValueBestTime
onready var medalTime = $VBoxContainer/HBoxContainer/MedalTime
onready var medalBestTime = $VBoxContainer/HBoxContainer2/MedalBestTime


onready var medalBronze = $VBoxContainer/HBoxContainerMedalValue/LabelBronze
onready var medalSilver = $VBoxContainer/HBoxContainerMedalValue/LabelSilver
onready var medalGold = $VBoxContainer/HBoxContainerMedalValue/LabelGold
onready var medalDiamond = $VBoxContainer/HBoxContainerMedalValue/LabelDiamond

var bronzeMedal = load("res://Sprites/BronzeMedal.png")
var silverMedal = load("res://Sprites/SilverMedal.png")
var goldMedal = load("res://Sprites/GoldMedal.png")

func _ready():
	#self.visible = false
	GameManager.endLevelUI = self
	
func _process(delta):
	if Input.is_action_just_released("reset"):
		GameManager.reset()


func setStartLevelUI(bestTime, medalValues, level, levelName):
	labelTime.visible = false
	valueTime.visible = false
	valueBestTime.visible = false
	setLevelName(levelName)
	setTimeStartLevel(bestTime)
	setMedalsStartLevel(bestTime, level)
	setMedalValues(medalValues)
	
func setEndLevelUI(time, bestTime, medalValues, level, levelName):
	labelTime.visible = true
	valueTime.visible = true
	valueBestTime.visible = true
	setLevelName(levelName)
	setTimeEndLevel(time, bestTime)
	setMedalsEndLevel(time, bestTime, level)
	setMedalValues(medalValues)

func setLevelName(levelName):
	labelLavelName.text = levelName

func setTimeStartLevel(bestTime):
	valueBestTime.text = GameManager.transformTime(bestTime)

func setTimeEndLevel(time, bestTime):
	valueTime.text = GameManager.transformTime(time)
	valueBestTime.text = GameManager.transformTime(bestTime)


func setMedalsStartLevel(bestTime, level):
	var medalBest = GameManager.getMedal(bestTime, level);
	matchMedal(medalBest, medalBestTime)
	
func setMedalsEndLevel(time, bestTime, level):
	var t = GameManager.wait(0.5)
	yield(t, "timeout")
	var medal = GameManager.getMedal(time, level);
	matchMedal(medal, medalTime)
	t = GameManager.wait(0.5)
	yield(t, "timeout")
	var medalBest = GameManager.getMedal(bestTime, level);
	matchMedal(medalBest, medalBestTime)

func setMedalValues(values):
	print(int(values[0]))
	print(GameManager.transformTime(int(values[0])))
	medalBronze.text = GameManager.transformTime(int(values[0]))
	medalSilver.text = GameManager.transformTime(int(values[1]))
	medalGold.text = GameManager.transformTime(int(values[2]))
	medalDiamond.text = GameManager.transformTime(int(values[3]))
	
func _on_Retry_pressed():
	GameManager.reset()


func _on_Next_pressed():
	GameManager.goToNextLevel()


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
