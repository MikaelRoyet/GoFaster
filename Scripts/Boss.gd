extends Area2D

var health = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.player.boss = self


func damage(value):
	health -= value
	flashingLights()
	if health <= 0:
		GameManager.endLevel()
		
func flashingLights():
	var shader = $Sprite.material
	shader.set_shader_param("white_progress", 1)
	var t = GameManager.wait(0.1)
	yield(t, "timeout")
	shader.set_shader_param("white_progress", 0)
	t = GameManager.wait(0.1)
	yield(t, "timeout")
	shader.set_shader_param("white_progress", 1)
	t = GameManager.wait(0.1)
	yield(t, "timeout")
	shader.set_shader_param("white_progress", 0)
	pass



