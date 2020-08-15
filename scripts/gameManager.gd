extends Spatial

func _ready():
	get_node("Barn/Cube021").set("health", Global.barnPercentage)
	Global.wolfCount = 0
	Global.ratCount = 0

func _process(delta):
	if get_tree().get_nodes_in_group("sheep").size() == 0 or get_node("Barn/Cube021").get("health") <= 0 :
		get_tree().change_scene("res://LoseScreen.tscn")
	Global.barnPercentage = get_node("Barn/Cube021").get("health")
	
	# trigger to go to the summery screen
	if Input.is_key_pressed(KEY_ENTER) :
		get_tree().change_scene("res://Summary1.tscn")
