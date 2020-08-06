extends Spatial

var rng = RandomNumberGenerator.new()
var ratScene = load("res://Rat.tscn")
onready var collisionShape = get_node("Area/CollisionShape")
onready var mainScene = get_parent()

func _ready():
	set_process(true)

func _process(_delta):
	var numberOfRats = get_tree().get_nodes_in_group("rat").size()
	if numberOfRats < 10 :
		var rat = ratScene.instance()
		var orgX = collisionShape.global_transform.origin.x
		var orgY = collisionShape.global_transform.origin.y
		var orgZ = collisionShape.global_transform.origin.z
		var xRange = collisionShape.shape.extents.x
		rng.randomize()
		var x = orgX + rng.randf_range(-xRange, xRange)
		rat.transform.origin = Vector3(x, orgY, orgZ)
		mainScene.add_child(rat)
