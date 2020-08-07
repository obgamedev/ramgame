extends KinematicBody

var SPEED = 10
var INERTIA = 10
var ACCELERATION = 2

var gravity = -9.8
var velocity = Vector3()
var flag = false

onready var animationTree = get_node("AnimationTree")

func _physics_process(delta):
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
