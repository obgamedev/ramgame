extends KinematicBody

var velocity = Vector3(0, 0, 0)
var gravity = -9.8
var camera

const SPEED = 30
const ACCELERATION = 2

onready var smokeParticles = get_node("Armature001/Skeleton/BodyBone/CPUParticles")
onready var animationPlayer = get_node("AnimationPlayer")

func _physics_process(delta):
	
	camera = get_node("Target/Camera").get_global_transform()
	
	# set up the xz plane movement (relevant to the camera)
	var dir = Vector3()
	if Input.is_key_pressed(KEY_W) : 
		dir -= camera.basis[2]
	if Input.is_key_pressed(KEY_S) : 
		dir += camera.basis[2]
	if Input.is_key_pressed(KEY_A) : 
		dir -= camera.basis[0]
	if Input.is_key_pressed(KEY_D) : 
		dir += camera.basis[0]
	dir.y = 0
	dir = dir.normalized()
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	
	hv = hv.linear_interpolate(new_pos, ACCELERATION * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	# rotation
	if velocity.x != 0 or velocity.z != 0 :
		rotation.y = atan2(hv.x, hv.z)
	
	# animation
	var currentAnimation
	if dir.x != 0 or dir.z != 0 :
		currentAnimation = "Dashing"
	else : 
		currentAnimation = "Still"
	
	if animationPlayer.current_animation != currentAnimation :
		animationPlayer.play(currentAnimation)
	
	if animationPlayer.current_animation == "Dashing" :
		animationPlayer.playback_speed = hv.length() / SPEED
	
	# particles
	if hv.length() <= SPEED / 3 :
		smokeParticles.emitting = false
	else :
		smokeParticles.emitting = true
