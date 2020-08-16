extends Node2D

var displayTime = 3
var elapsedTime = 0
#
var flag = false
var flag2 = false
var timer
var nutimer

onready var Barn = $Sprite/Barn
onready var Rats = $Sprite/Rats
onready var Wolvs = $Sprite/Wolvs
onready var FadeOut = $AnimationPlayer
onready var player = $AnimationPlayer2

func _ready():
	Barn.text = str(Global.barnPercentage)
	Rats.text = str(Global.ratCount)
	Wolvs.text = str(Global.wolfCount)
	#shittin up your beutiful code
	timer = Timer.new()
	timer.set_wait_time(0.5)
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer) #to process
	timer.start() #to start
	#
	nutimer = Timer.new()
	nutimer.set_wait_time(3)
	nutimer.connect("timeout",self,"_on_nutimer_timeout") 
	add_child(nutimer) #to process
	nutimer.start() #to start

func _process(delta):
	# trigger to go to next level
#	elapsedTime += delta
#	if elapsedTime > displayTime :
#above is nice and smaht, but this allows for taking control
	if flag and flag2 and !FadeOut.is_playing() :
		Global.currentLevel += 1
		if Global.currentLevel == 2 :
			get_tree().change_scene("res://Poem2.tscn")
		elif Global.currentLevel == 3 :
			get_tree().change_scene("res://Poem3.tscn")
		else :
			get_tree().change_scene("res://LoseScreen.tscn")

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and flag:
			FadeOut.play("FadeOut")
			flag2 = true

func _on_timer_timeout():
	player.play("summaryscroll")
	timer.queue_free()
	pass

func _on_nutimer_timeout():
	flag = true
	nutimer.queue_free()
	pass
