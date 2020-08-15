extends Camera

var distance
var height
var shakeOffset = Vector3()
var shakeTimeRemaining = 0
var shakeIntensity = 0.4 #0.3

var slightShakeOffset = Vector3()
var slightShakeTimeRemaining = 0
var slightShakeIntensity = 0.2#0.13

var rng = RandomNumberGenerator.new()
onready var ram = get_node("../..")

func _ready():
	set_as_toplevel(true)
	set_physics_process(true)
	
	# height and distance to maintain
	height = get_global_transform().origin.y
	distance = (get_global_transform().origin - get_parent().get_global_transform().origin).length()
	ram.connect("shake", self, "_camera_shake")
	ram.connect("slight_shake", self, "_slight_camera_shake")

func _physics_process(delta):
	
	# follow target node
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0, 1, 0)
	
	var offset = pos - target
	offset = offset.normalized() * distance
	offset.y = height
	
	pos = target + offset
	
	shakeOffset = Vector3()
	slightShakeOffset = Vector3()
	
	if shakeTimeRemaining > 0 :
		shakeTimeRemaining -= delta
		rng.randomize()
		shakeOffset.x = shakeIntensity * rng.randf_range(-1, 1)
		rng.randomize()
		shakeOffset.y = shakeIntensity * rng.randf_range(-1, 1)
		rng.randomize()
		shakeOffset.z = shakeIntensity * rng.randf_range(-1, 1)
	
	if slightShakeTimeRemaining > 0 :
		slightShakeTimeRemaining -= delta
		rng.randomize()
		slightShakeOffset.x = slightShakeIntensity * rng.randf_range(-1, 1)
		rng.randomize()
		slightShakeOffset.y = slightShakeIntensity * rng.randf_range(-1, 1)
		rng.randomize()
		slightShakeOffset.z = slightShakeIntensity * rng.randf_range(-1, 1)
	
	# look at target node
	look_at_from_position(pos + shakeOffset + slightShakeOffset, target+ shakeOffset + slightShakeOffset, up)

func _camera_shake() :
	shakeTimeRemaining = 0.5

func _slight_camera_shake() :
	slightShakeTimeRemaining = 0.1
