extends Spatial


func _process(delta):
	if get_tree().get_nodes_in_group("sheep").size() == 0 :
		get_tree().change_scene("res://LoseScreen.tscn")
