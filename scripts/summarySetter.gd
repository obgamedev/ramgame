extends Node2D

var displayTime = 3
var elapsedTime = 0

onready var Barn = $Sprite/Barn
onready var Rats = $Sprite/Rats
onready var Wolvs = $Sprite/Wolvs

func _ready():
	Barn.text = str(Global.barnPercentage)
	Rats.text = str(Global.ratCount)
	Wolvs.text = str(Global.wolfCount)

func _process(delta):
	# trigger to go to next level
	elapsedTime += delta
	if elapsedTime > displayTime :
		Global.currentLevel += 1
		if Global.currentLevel == 2 :
			get_tree().change_scene("res://Poem2.tscn")
		elif Global.currentLevel == 3 :
			get_tree().change_scene("res://Poem3.tscn")
		else :
			get_tree().change_scene("res://LoseScreen.tscn")
