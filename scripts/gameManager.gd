extends Spatial

var timePerLevel = 60
var timeElapsed = 0
onready var sceneName = get_tree().get_current_scene().get_name()

onready var timerTextLabel = get_node("Timer/RichTextLabel")

func _ready():
	get_node("Barn/Cube021").set("health", Global.barnPercentage)
	Global.wolfCount = 0
	Global.ratCount = 0
	set_process(true)
	if sceneName == "Main":
		timePerLevel = 15
	elif sceneName == "SemiRainy":
		timePerLevel = 30
	elif sceneName == "RainLevel":
		timePerLevel = 60

func _process(delta):
	if get_tree().get_nodes_in_group("sheep").size() == 0 or get_node("Barn/Cube021").get("health") <= 0 :
		get_tree().change_scene("res://LoseScreen.tscn")
	Global.barnPercentage = get_node("Barn/Cube021").get("health")
	
	# timer display
	timeElapsed += delta
	var timeLeft = timePerLevel - floor(timeElapsed)
	
	timerTextLabel.text = str(timeLeft)
	
	# trigger to go to the summery screen
	if timeLeft <= 0 :
		get_tree().change_scene("res://Summary1.tscn")
