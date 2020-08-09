extends RigidBody

var rng = RandomNumberGenerator.new()

var SPEED = 10
var MAX_HEALTH = 100

enum {IDLE_STATE, WALKING_STATE, DEAD_STATE, HURT_STATE}
var state
var timeRemaining
var dir = Vector2(0, 0)
var velocity = Vector2(0, 0)
var health = MAX_HEALTH

onready var animationTree = get_node("AnimationTree")
onready var mesh = get_node("Armature002/Skeleton/Cube011")

func _ready():
	# set state and timer
	rng.randomize()
	state = IDLE_STATE
	timeRemaining = rng.randf_range(0.5, 2)

# hit by wolf
func _on_Area_body_entered(body):
	if state == HURT_STATE :
		timeRemaining = 3
		return
	if !body.is_in_group("wolf") :
		return
	health -= 40
	if health <= 0 :
		state = DEAD_STATE
	else :
		rng.randomize()
		dir = 3 * Vector2(global_transform.origin.x - body.global_transform.origin.x, global_transform.origin.z - body.global_transform.origin.z).normalized()
		set_velocity()
		rotation.y = atan2(dir.x, dir.y)
		timeRemaining = 3
		state = HURT_STATE

func _physics_process(delta):
	
	if state == DEAD_STATE :
		queue_free()
	
	# move randomly
	rng.randomize()
	if state == HURT_STATE and rng.randf_range(0, 10) <= 0.2 :
		dir = 3 * Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
		set_velocity()
		rotation.y = atan2(dir.x, dir.y)
	
	# blinking red (bug : effects all objects with the same material)
	if state == HURT_STATE :
		mesh.get_surface_material(0).albedo_color = Color.red if Engine.get_frames_drawn() % 2 == 0 else Color.white
	
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
		elif state == WALKING_STATE :
			state = IDLE_STATE
			dir = Vector2(0, 0)
		elif state == HURT_STATE :
			state = IDLE_STATE
			mesh.get_surface_material(0).albedo_color = Color.white
			dir = Vector2(0, 0)
		
		set_velocity()
	
	# animation
	animationTree.set("parameters/my_blend/blend_amount",  linear_velocity.length() / SPEED)

func set_velocity() :
	velocity = dir * SPEED
	linear_velocity = Vector3(velocity.x, 0, velocity.y)
