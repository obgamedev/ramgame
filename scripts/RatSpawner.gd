extends Spatial

var rng = RandomNumberGenerator.new()
var ratScene = load("res://Rat.tscn")
onready var collisionShape = get_node("Area/CollisionShape")
onready var mainScene = get_parent()
var LevelNumber
onready var sceneName = get_tree().get_current_scene().get_name()

func _ready():
	set_process(true)
	if sceneName == "Main":
		LevelNumber = 3
	elif sceneName == "SemiRainy":
		LevelNumber = 10
	elif sceneName == "RainLevel":
		LevelNumber = 20

func _process(_delta):
	var numberOfRats = get_tree().get_nodes_in_group("rat").size()
	if numberOfRats < LevelNumber:
		var rat = ratScene.instance()
		var orgX = collisionShape.global_transform.origin.x
		var orgY = collisionShape.global_transform.origin.y
		var orgZ = collisionShape.global_transform.origin.z
		var xRange = collisionShape.shape.extents.x
		rng.randomize()
		var x = orgX + rng.randf_range(-xRange, xRange)
		rat.transform.origin = Vector3(x, orgY, orgZ)
		mainScene.add_child(rat)


