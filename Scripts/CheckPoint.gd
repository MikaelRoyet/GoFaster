extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	connect("body_entered", self, "_on_Player_body_entered")


func _on_Player_body_entered(body):
	if (body.get_name() == "Player"):
		body.setCheckpoint(self)
