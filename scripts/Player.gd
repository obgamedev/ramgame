extends KinematicBody

var velocity = Vector3(0, 0, 0)
const SPEED = 6
const GRAVITY = 0.1
const mouseSensitivity = 0.7

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion :
		rotate_y(deg2rad(-event.relative.x * mouseSensitivity))

func _physics_process(delta):
	
	velocity.x = 0
	velocity.z = 0
	var dx = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
	var dz = int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))
	velocity += dx * transform.basis.x * SPEED
	velocity += dz * transform.basis.z * SPEED
	velocity.y -= GRAVITY
	velocity = move_and_slide(velocity, Vector3.UP)
