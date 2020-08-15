extends KinematicBody

var SPEED = 10
var INERTIA = 10
var ACCELERATION = 2
var MAX_HEALTH = 100
enum {HUNT_STATE, HURT_STATE}

var gravity = -9.8
var velocity = Vector3()
var flag = false
var health = MAX_HEALTH
var state = HUNT_STATE
var timeRemaining = 0
var hitVelocity

onready var animationTree = get_node("AnimationTree")
onready var mesh = get_node("wolf/Armature007/Skeleton/Cube015")

func _physics_process(delta):
	
	if state == HURT_STATE :
		mesh.get_surface_material(0).albedo_color = Color.red if Engine.get_frames_drawn() % 2 == 0 else Color.white
		hitVelocity *= 0.9
		velocity = hitVelocity * SPEED * 10
		velocity = move_and_slide(velocity, Vector3.UP, false, 4, PI / 4, false)
		timeRemaining -= delta
		
		if timeRemaining <= 0 :
			timeRemaining = 0
			mesh.get_surface_material(0).albedo_color = Color.white
			health -= 40
			if health <= 0 :
				Global.wolfCount += 1
				queue_free()
			state = HUNT_STATE
	elif state == HUNT_STATE :
		# move towards closest sheep
		var distance = get_closest_sheep_coordinates() - global_transform.origin
		distance.y = 0
		var direction = distance.normalized()
		var hv = Vector3()
		hv.x = direction.x * SPEED
		hv.z = direction.z * SPEED
		hv.y = velocity.y + gravity * delta
		
		velocity = velocity.linear_interpolate(hv, ACCELERATION * delta)
		velocity.y = hv.y
		velocity = move_and_slide(velocity, Vector3.UP, false, 4, PI / 4, false)
		rotation.y = atan2(direction.x, direction.z)
		
		# check if hit by ram
		for i in get_slide_count() :
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("ram") :
				hitVelocity = collision.normal
				state = HURT_STATE
				timeRemaining = 0.5
				return
		
		# attack animation
		if distance.length() < 13.5 && !flag :
			flag = true
			animationTree.set("parameters/my_one_shot/active",  true)
		elif distance.length() >= 13.5 && flag :
			flag = false

func get_closest_sheep_coordinates():
	var sheeps = get_tree().get_nodes_in_group("sheep")
	if sheeps.size() == 0 :
		return Vector3(0, 0, 0)
	var closestSheep = sheeps[0]
	for sheep in sheeps :
		if sheep.global_transform.origin.distance_to(global_transform.origin) < closestSheep.global_transform.origin.distance_to(global_transform.origin) :
			closestSheep = sheep
	return closestSheep.global_transform.origin
