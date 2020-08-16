extends Spatial

var rng = RandomNumberGenerator.new()
var wolfScene = load("res://Wolf.tscn")
onready var collisionShape = get_node("Area/CollisionShape")
onready var mainScene = get_parent()
var LevelNumber
onready var sceneName = get_tree().get_current_scene().get_name()

func _ready():
	set_process(true)
	if sceneName == "Main":
		LevelNumber = 0
	elif sceneName == "SemiRainy":
		LevelNumber = 1
	elif sceneName == "RainLevel":
		LevelNumber = 1

func _process(_delta):
	var numberOfWolves = get_tree().get_nodes_in_group("wolf").size()
	if numberOfWolves < LevelNumber:
		var wolf = wolfScene.instance()
		var orgX = collisionShape.global_transform.origin.x
		var orgY = collisionShape.global_transform.origin.y
		var orgZ = collisionShape.global_transform.origin.z
		var xRange = collisionShape.shape.extents.x
		var zRange = collisionShape.shape.extents.z
		rng.randomize()
		var x = orgX + rng.randf_range(-xRange, xRange)
		var z = orgZ + rng.randf_range(-zRange, zRange)
		wolf.transform.origin = Vector3(x, orgY, z)
		mainScene.add_child(wolf)
