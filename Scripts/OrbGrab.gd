extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var arrow = get_node("Arrow")
var playerPosition = Vector2.ZERO
var typeGrab = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func OrbGrab():
	pass
	
func _process(delta):
	if(playerPosition != Vector2.ZERO):
		arrow.visible = true
		arrow.look_at(playerPosition)
	else:
		arrow.visible = false


func getPlayer(position):
	playerPosition = position
	
func removePlayer():
	playerPosition = Vector2.ZERO
