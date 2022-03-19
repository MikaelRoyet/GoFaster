extends HBoxContainer


onready var button = $Button
onready var time = $Time
onready var medal = $Medal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setAllValues(level, levelName, timeValue, medalValue):
	button.name = level
	button.text = levelName
	
	if timeValue != 0:
		time.text = str(GameManager.transformTime(timeValue))
	else:
		time.visible = false
	
	medal.texture = medalValue
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
