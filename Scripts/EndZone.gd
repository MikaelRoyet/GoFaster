extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var isConnected = false
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if GameManager.player != null && isConnected == false:
		connect("body_entered", GameManager.player, 'handle_entered_endZone')
		isConnected = true

func _ready():
	connect("body_entered", EventHandler, 'handle_entered_endZone', )
