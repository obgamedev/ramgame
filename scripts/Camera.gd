extends Camera

var distance
var height

func _ready():
	set_as_toplevel(true)
	set_physics_process(true)
	
	# height and distance to maintain
	height = get_global_transform().origin.y
	distance = (get_global_transform().origin - get_parent().get_global_transform().origin).length()

func _physics_process(_delta):
	
	# follow target node
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0, 1, 0)
	
	var offset = pos - target
	offset = offset.normalized() * distance
	offset.y = height
	
	pos = target + offset
	
	# look at target node
	look_at_from_position(pos, target, up)
