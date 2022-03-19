extends Container


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = $Panel/HBoxContainer/Timer
onready var levelName = $Panel/HBoxContainer/LevelName
var startTime = 0
var stopTime = false
var finalTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.levelUI = self
	startTime = OS.get_ticks_msec()
	levelName.text = get_tree().get_current_scene().get_name()
	
	
func _process(delta):
	if(!stopTime):
		timer.text = GameManager.transformTime(getTime())



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func getTime():
	var time_now = float(OS.get_ticks_msec())
	var time_elapsed = time_now - startTime - 750
	return time_elapsed
	
func stopTime():
	return getTime()

