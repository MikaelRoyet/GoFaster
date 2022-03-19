extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tutoDict = {
	"TutoTrigger0": "Press space to jump, the longer you press it the higher you go ",
	"TutoTrigger1": "Press A were you are close of red orbs to bounce on it. Doing this will reset your jump : ",
	"TutoTrigger2": "Bouncing on red orbs will speed you up. If you touch the ground you will be back at basic speed",
	"TutoTrigger3": "By pressing Z you can grab blue orbs and be push to it. The arrow indicate the direction you will go. If there's no arrow then you are not in range of grabbing",
}
# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = tutoDict["TutoTrigger0"]

func setText(nameTuto):
	self.text = tutoDict[nameTuto]
