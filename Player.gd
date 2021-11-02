extends KinematicBody

var speed = 10
var acceleration = 30
var gravity = 40
var jump = 16

var mouse_sensitivity = 0.5

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head
onready var anim_play = $Head/Camera/AnimationPlayer
onready var footstepPlayer = $WalkSound

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func playFootstep(): 
	if is_on_floor():
		var rand = floor(rand_range(0, 6))
		match str(rand):
			"0":
				footstepPlayer.stream = preload("res://assets/sounds/footstep1.mp3")
			"1":
				footstepPlayer.stream = preload("res://assets/sounds/footstep2.mp3")
			"2":
				footstepPlayer.stream = preload("res://assets/sounds/footstep3.mp3")
			"3":
				footstepPlayer.stream = preload("res://assets/sounds/footstep4.mp3")
			"4":
				footstepPlayer.stream = preload("res://assets/sounds/footstep5.mp3")
			"5":
				footstepPlayer.stream = preload("res://assets/sounds/footstep6.mp3")
		footstepPlayer.play();

func _process(delta):
	direction = Vector3()
	
	if not is_on_floor():
		fall.y -= gravity * delta	
	elif Input.is_action_pressed("jump"):
		fall.y = jump
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	move_and_slide(fall, Vector3.UP)
	
	if direction != Vector3():
		anim_play.play("Head Bob")
	
