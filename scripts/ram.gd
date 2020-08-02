extends KinematicBody

var velocity = Vector3(0, 0, 0)
const SPEED = 20
const GRAVITY = 0.1
const MOUSE_SENSITIVITY = 0.7
const TIMER = 1
var timeRemaining = 0

onready var animationPlayer = get_node("AnimationPlayer")

func _ready():
	# lock mouse inside game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# move camera horizontally
	if event is InputEventMouseMotion :
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))

func _physics_process(delta):
	
	# set up the xz plane movement
	velocity.x = 0
	velocity.z = 0
	var dx = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
	var dz = int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))
	velocity -= dx * transform.basis.x * SPEED
	velocity -= dz * transform.basis.z * SPEED
	
	# gravity effect
	velocity.y -= GRAVITY
	
	# movement
	velocity = move_and_slide(velocity, Vector3.UP)
	
	# animation
	if dx != 0 or dz != 0 :
		animationPlayer.play("default")
	else :
		animationPlayer.stop()
	
	# dynamic camera
	if timeRemaining >= 0 :
		timeRemaining -= delta
		if timeRemaining <= 0 :
			timeRemaining = 0
			get_node("Pivot/Camera").current = true

func _on_Area_body_entered(body):
	get_node("Pivot/DynamicCamera").current = true
	timeRemaining = TIMER
