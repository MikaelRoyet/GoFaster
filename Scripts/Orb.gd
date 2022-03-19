extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var deathAnim = $DeathAnim
var spriteHighlightOrb = load('res://Sprites/OrbHighlight.png')
var spriteOrb = load('res://Sprites/orb.png')
var isDead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func OrbDelete():
	deathAnim.play()
	$Sprite.visible = false
	isDead = true
	deathAnim.play()
	yield(deathAnim, "animation_finished")
	get_parent().remove_child(self)

func OrbHighlight():
	var childNode = $Sprite
	childNode.texture = spriteHighlightOrb

func OrbUnHighlight():
	var childNode = $Sprite
	childNode.texture = spriteOrb
