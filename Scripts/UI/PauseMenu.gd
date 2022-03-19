extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isPause = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if !isPause:
			get_tree().paused = true
			self.visible = true
			isPause = !isPause
		else:
			resume()

		



func resume():
	get_tree().paused = false
	self.visible = false
	isPause = !isPause
	
func restart():
	get_tree().paused = false
	GameManager.reset()
	
func quit():
	get_tree().paused = false
	GameManager.mainMenu()


func _on_Resume_pressed():
	resume()


func _on_Restart_pressed():
	restart()


func _on_Quit_pressed():
	quit()
