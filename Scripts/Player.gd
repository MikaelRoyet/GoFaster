extends KinematicBody2D

#Particles
var particleCircle = load("res://prefab/Particles/ParticleCircle.tscn")
var particleJump = load("res://prefab/Particles/JumpParticle.tscn")
var particleBunny = load("res://prefab/Particles/ParticleBunny.tscn")
var spriteNoJump = load("res://Sprites/playerNoJump.png")
var spriteJump = load("res://Sprites/Player.png")
var spritePlayerInAir = load("res://Sprites/PlayerInAirSprite.png")
var spritePlayerGround = load("res://Sprites/Player.png")

#Autres
var boss = null

#Movements
const GRAVITY = 20
const REBOUND = 400
const SPEED_MAX = 250
const SPEED_MIN = 250
const SPEED_UP = 50
const SPEED_VERTICAL_UP_MAX = 5000
const SPEED_VERTICAL_DOWN_MAX = 1000
const GRAB = 500
const SPEED_GLIDING = 7
var speed = 35
var maxSpeed = SPEED_MAX
var motion = Vector2()
var canJump = true
const MIN_JUMP_HEIGHT = -150
const MAX_JUMP_HEIGHT = -600
var timeHeld = 0
var timeForFullJump = 0.1
var isGrabbing = false
var timerGrabDuration = 250
var timerGrab = 0
var goingRight = true
var isDashing = false

#la glissade
var isSliding = false
var horizontalPos = 0

#Bunny jump
var timerBunnyDuration = 100
var timerBunny = 0
var canBunny = false

#Buffer Jump
const JUMP_BUFFER_FRAMES = 6
var jumpBuffer
var isJumpBufferStarted = false

#Sound
onready var soundJump = $Sound/SoundJump
onready var soundBounce = $Sound/SoundBounce
onready var soundGrab = $Sound/SoundGrab
onready var animator = $Animator


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.player = self
	print(GameManager.checkpoint)
	if(GameManager.checkpoint > 0):
		self.set_position(get_parent().get_node("CheckPoints/CheckPoint" + str(GameManager.checkpoint)).get_node("Respawn").global_position)
	setProcess(false)

	

func _process(delta):
	pass

func _physics_process(delta):
	
	motion.y += GRAVITY

	if isJumpBufferStarted:
		jumpBuffer -= 1
		if jumpBuffer <= 0:
			isJumpBufferStarted = false
	



	if !isGrabbing:
		
		
		if get_input_axis() > 0:
			if(!goingRight):
				goingRight = true
				maxSpeed -= speed / 5
		elif get_input_axis() < 0:
			if(goingRight):
				goingRight = false
				maxSpeed -= speed / 5

		if get_input_axis() == 0:
			if motion.x > speed:
				 motion.x -= speed
			elif motion.x < -speed:
				motion.x += speed
			else:
				motion.x = 0
			
		motion.x = clamp(motion.x + get_input_axis() * speed, -maxSpeed, maxSpeed)
	else:
		if get_input_axis() > 0:
			if(!goingRight):
				goingRight = true
		else:
			if(goingRight):
				goingRight = false
		
	
	if Input.is_action_just_pressed("circle"):
		circle()
		
	if Input.is_action_just_pressed("grab") and !isGrabbing:
		grab()
		
	if Input.is_action_just_released("reset"):
		GameManager.reset()
	
	if is_on_floor():
		#animator.play("Bounce")
		animator.play("Idle")
		canJump = true
		
		#spritePlayer.texture = spriteJump
		if !canBunny:
			isSliding = true
			print("GLIDING START")
			horizontalPos = self.position.y - 1
			timerBunny = getTime() + timerBunnyDuration
			canBunny = true
			
		if timerBunny < getTime() && !isSliding:
			maxSpeed = SPEED_MIN
	else:
		pass#spritePlayer.texture = spritePlayerInAir
		
	if isGrabbing and timerGrab < getTime():
		isGrabbing = false
		isDashing = false
		
	if isSliding:
		if horizontalPos < self.position.y:
			horizontalPos = self.position.y
			maxSpeed += SPEED_GLIDING
			
		else:
			isSliding = false
			
	
		
	checkPoints()
	checkGrabs()
	jump(delta)
	
	motion = move_and_slide(motion, Vector2.UP)
	#var angle = position + motion
	#look_at(angle)


#MOUVEMENT FUNC

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.get_action_strength("right")) - int(Input.get_action_strength("left"))
	return axis.normalized().x



func circle():
	var childNode = $Circle 
	var reset = childNode.attack()
	if reset:
		soundBounce.play()
		particleCircle()
		motion.y = -REBOUND
		canJump = true
		maxSpeed += SPEED_UP
		animator.play("Idle")
		
func grab():
	var childNode = $GrabZone 
	var grab = childNode.grab()
	if grab != null:
		if childNode.typeGrab == 0:
			motion = (grab.global_position - position).normalized() * (GRAB + maxSpeed)
			timerGrab = getTime() + timerGrabDuration
			isGrabbing = true
			canJump = true
			soundGrab.play()
			animator.play("IdleAir")
		elif childNode.typeGrab == 1:
			motion = (grab.global_position - position).normalized() * (GRAB + maxSpeed) * 3
			timerGrab = getTime() + timerGrabDuration
			isGrabbing = true
			isDashing = true
			canJump = true
			soundGrab.play()
			animator.play("IdleAir")


func getTime():
	var time_start = 0
	var time_now = 0
	time_now = OS.get_ticks_msec()
	var time_elapsed = time_now - time_start
	return time_elapsed

func jump(delta):
	
	#BufferJump
	if Input.is_action_just_pressed("jump"):
		isJumpBufferStarted = true
		jumpBuffer = JUMP_BUFFER_FRAMES
	
	if isJumpBufferStarted && canJump:

		timeHeld += delta
		motion.y = MAX_JUMP_HEIGHT
		soundJump.play()
		animator.play("Idle")
		
		if canBunny:
			particleBunny()
		else:
			particleJump()
			
		canJump = false
		canBunny = false
		
	if Input.is_action_just_released("jump") and !isGrabbing:
		motion.y = 0 if motion.y < 0 else motion.y

func checkPoints():
	var childNode = $Circle 
	childNode.highlight()
	
func checkGrabs():
	var childNode = $GrabZone 
	childNode.highlight(global_position)
	
func particleCircle():
	var particle_instance = particleCircle.instance()
	particle_instance.set_name("ParticleCircle")
	add_child(particle_instance)
	particle_instance.emitting = true
	
func particleJump():
	var particle_instance = particleJump.instance()
	particle_instance.set_name("ParticleJump")
	add_child(particle_instance)
	particle_instance.emitting = true

func particleBunny():
	var particle_instance = particleBunny.instance()
	particle_instance.set_name("ParticleBunny")
	add_child(particle_instance)
	particle_instance.emitting = true

func setProcess(b):
	animator.visible = b
	set_physics_process(b)


func _on_DeathZone_body_entered(body):
	if body.is_in_group("player"):
		print("death")
		GameManager.reset()




func _on_EndZone_body_entered(body):
	if body.is_in_group("player"):
		print("endlevel")
		GameManager.endLevel()



func _on_Boss_body_entered(body):
		if body.is_in_group("player"):
			if isDashing:
				boss.damage(1)
			else:
				GameManager.reset()



func _on_Area2D_body_entered(body):
	print('enter')
	if body.is_in_group("Wall"):
		print('enter2')
		if isDashing:
			print('enter3')
			body.queue_free()
		else:
			pass



func handle_entered_endZone():
	print("handle_entered_endZone")

