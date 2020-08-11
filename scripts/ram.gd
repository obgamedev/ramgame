extends KinematicBody

var velocity = Vector3(0, 0, 0)
var gravity = -9.8
var camera
var currentAnimation

signal shake
signal slight_shake

const SPEED = 50
const ACCELERATION = 2
const INERTIA = 3
const smokeResizeRation = 0.9

onready var smokeParticles = get_node("Armature001/Skeleton/BodyBone/CPUParticles")
onready var animationTree = get_node("AnimationTree")

func _physics_process(delta):
	#CW: terrible coooode ahead! its a restart button
	if Input.is_action_just_pressed("ui_end"):
		get_tree().reload_current_scene()
	#bad code ends here
	
	camera = get_node("Target/Camera").get_global_transform()
	
	# set up the xz plane movement (relevant to the camera)
	var dir = Vector3()
	if Input.is_action_pressed("Up") : 
		dir -= camera.basis[2]
	if Input.is_action_pressed("Down") : 
		dir += camera.basis[2]
	if Input.is_action_pressed("Left") : 
		dir -= camera.basis[0]
	if Input.is_action_pressed("Right") : 
		dir += camera.basis[0]
	dir.y = 0
	dir = dir.normalized()
	velocity.y += gravity * delta
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	
	hv = hv.linear_interpolate(new_pos, ACCELERATION * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3.UP, false, 4, PI / 4, false)
	
	for i in get_slide_count() :
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("sheep") :
			collision.collider.apply_central_impulse(-collision.normal * INERTIA)
		elif collision.collider.is_in_group("rat") :
			collision.collider.apply_central_impulse(-collision.normal * INERTIA * 10)
		elif collision.collider.is_in_group("wolf") :
			emit_signal("shake")
	
	# rotation
	if dir.x != 0 or dir.z != 0 :
		for c in range(10) :
			var targetRotation = atan2(hv.x, hv.z)
			var diff = targetRotation - rotation.y
			if diff < 0 :
				diff += PI * 2
			if diff < PI :
				rotation.y += 0.01
			else :
				rotation.y -= 0.01
	
	# animation
	if dir.x != 0 or dir.z != 0 :
		currentAnimation = "Dashing"
	else : 
		currentAnimation = "Still"
	
	animationTree.set("parameters/my_blend/blend_amount",  hv.length() / SPEED)
	
	# particles
	if hv.length() <= SPEED / 3 :
		smokeParticles.emitting = false
	else :
		smokeParticles.emitting = true
		emit_signal("slight_shake")
	
	#particles get smaller with time. WELL, THEY SHOULD!!!!!
	#var mesh = smokeParticles.mesh 
	#mesh.size -= Vector2(delta, delta)
	
	#ramming anim. does not work!! required a named node, but we are generating rats!
	#var rat = get_tree().get_root().find_node("Rat?",true,false)
	#if !rat == null:
	#	rat.connect("rathit",self,"ram")

# close to rat
func _on_Area_body_entered(_body):
	# play ramming animation if ram fast enough
	if velocity.length() >= SPEED / 3 :
		animationTree.set("parameters/my_one_shot/active",  true)
