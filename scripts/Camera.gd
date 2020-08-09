extends Camera

var distance
var height
var shakeOffset = Vector3()
var shakeTimeRemaining = 0
var shakeIntensity = 0.3

var rng = RandomNumberGenerator.new()
onready var ram = get_node("../..")

func _ready():
	set_as_toplevel(true)
	set_physics_process(true)
	
	# height and distance to maintain
	height = get_global_transform().origin.y
	distance = (get_global_transform().origin - get_parent().get_global_transform().origin).length()
	ram.connect("shake", self, "_camera_shake")

func _physics_process(delta):
	
	# follow target node
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0, 1, 0)
	
	var offset = pos - target
	offset = offset.normalized() * distance
	offset.y = height
	
	pos = target + offset
	
	if shakeTimeRemaining > 0 :
		shakeTimeRemaining -= delta
		rng.randomize()
		shakeOffset.x = shakeIntensity * rng.randf_range(-1, 1)
		rng.randomize()
		shakeOffset.y = shakeIntensity * rng.randf_range(-1, 1)
		rng.randomize()
		shakeOffset.z = shakeIntensity * rng.randf_range(-1, 1)
	
	# look at target node
	look_at_from_position(pos + shakeOffset, target+ shakeOffset, up)

func _camera_shake() :
	shakeTimeRemaining = 0.5
