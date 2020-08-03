extends RigidBody

var rng = RandomNumberGenerator.new()

enum {IDLE_STATE, WALKING_STATE, DEAD_STATE}
var state
var timeRemaining
var dir = Vector2(0, 0)
var velocity = Vector2(0, 0)

var SPEED = 10

onready var animationTree = get_node("AnimationTree")

func _ready():
	# set state and timer
	rng.randomize()
	state = IDLE_STATE
	timeRemaining = rng.randf_range(0.5, 2)

# fly away
func _on_Area_body_entered(body):
	var dir = Vector3(sign(global_transform.origin.x - body.global_transform.origin.x), 1, sign(global_transform.origin.z - body.global_transform.origin.z))
	linear_velocity = Vector3(0, 0, 0)
	apply_central_impulse(dir * 5)
	apply_torque_impulse(dir)
	state = DEAD_STATE

func _physics_process(delta):
	
	if state == DEAD_STATE :
		return
	
	# decrement timer and check it
	timeRemaining -= delta
	if timeRemaining <= 0 :
		# reset timer
		rng.randomize()
		timeRemaining = rng.randf_range(2, 5)
		# change state and direction
		if state == IDLE_STATE :
			state = WALKING_STATE
			dir = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
			rotation.y = atan2(dir.x, dir.y)
		else :
			state = IDLE_STATE
			dir = Vector2(0, 0)
		
		# set velocity
		velocity = dir * SPEED
		linear_velocity = Vector3(velocity.x, 0, velocity.y)
	
	# animation
	animationTree.set("parameters/my_blend/blend_amount",  linear_velocity.length() / SPEED)
