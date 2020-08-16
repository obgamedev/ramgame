extends Spatial

onready var poem = $AnimationPlayer
onready var scroll = $AnimationPlayer3
onready var FadeOut = $AnimationPlayer4
onready var Noise = $AudioStreamPlayer
var timer
var nutimer
var soundtimer
signal finished

var flag = false
var flag2 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.set_wait_time(3)
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer) #to process
	timer.start() #to start
	#timer 2
#	nutimer = Timer.new()
#	nutimer.set_wait_time(6)
#	nutimer.connect("timeout",self,"_on_nutimer_timeout") 
#	add_child(nutimer) #to process
#	nutimer.start() #to start
	soundtimer = Timer.new()
	soundtimer.set_wait_time(0.4)
	soundtimer.connect("timeout",self,"_on_soundtimer_timeout") 
	add_child(soundtimer) #to process
	soundtimer.start() #to start
	soundtimer.emit_signal("finished", self)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if flag and !FadeOut.is_playing():
		print(Global.currentLevel)
		Global.barnPercentage = Global.prevBarnPercentage
		if Global.currentLevel == 1 :
			get_tree().change_scene("res://MainGame.tscn")
		elif Global.currentLevel == 2 :
			get_tree().change_scene("res://Level2-SemiRainy.tscn")
		elif Global.currentLevel == 3 :
			get_tree().change_scene("res://RainLevel.tscn")
	
#	# fading started
#	if FadeOut.is_playing() :
#		flag = true
#
#	# fading finished
#	if flag and !FadeOut.is_playing() :
##		var sceneName = get_tree().get_current_scene().get_name()
##		if sceneName == "Intro.tscn" :
#		get_tree().change_scene("res://Poem1.tscn")
	
func _on_timer_timeout():
	poem.play("PoemScroll")
	timer.queue_free()
	flag2 = true
	pass

func _on_soundtimer_timeout():
	scroll.play("introscroll")
	Noise.play()
	soundtimer.queue_free()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and flag2:
			FadeOut.play("my_anim")
			flag = true

#func _on_AudioStreamPlayer_finished():
#	Noise.volume_db(0)
#	pass # Replace with function body.
