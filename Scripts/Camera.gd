extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var topLeft = $TopLeft
onready var bottomRight = $BottomRight

# Called when the node enters the scene tree for the first time.
func _ready():
	limit_top = topLeft.global_position.y
	limit_left = topLeft.global_position.x
	limit_bottom = bottomRight.global_position.y
	limit_right = bottomRight.global_position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
