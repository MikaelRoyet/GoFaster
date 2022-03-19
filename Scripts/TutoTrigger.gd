extends Area2D


var textBox

func _ready():
	connect("body_entered", self, "_on_Player_body_entered")
	textBox = get_parent().get_parent().get_node("CanvasTuto/TutoTextBox")


func _on_Player_body_entered(body):
	if (body.get_name() == "Player"):
		textBox.setText(name)
