extends Spatial

onready var Scroll = $AnimationPlayer3
onready var FadeOut = $AnimationPlayer2
onready var Noise = $AudioStreamPlayer
var timer
var nutimer
var soundtimer
signal finished

var flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.set_wait_time(0.5)
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer) #to process
	timer.start() #to start
	#timer 2
	nutimer = Timer.new()
	nutimer.set_wait_time(6)
	nutimer.connect("timeout",self,"_on_nutimer_timeout") 
	add_child(nutimer) #to process
	nutimer.start() #to start
	soundtimer = Timer.new()
	soundtimer.set_wait_time(0.4)
	soundtimer.connect("timeout",self,"_on_soundtimer_timeout") 
	add_child(soundtimer) #to process
	soundtimer.start() #to start
	soundtimer.emit_signal("finished", self)

func _process(delta):
	# fading started
#	if FadeOut.is_playing() :
#		flag = true
	
	# fading finished
	if flag and !FadeOut.is_playing() :
#			var sceneName = get_tree().get_current_scene().get_name()
#			if sceneName == "Intro.tscn" :
				get_tree().change_scene("res://Poem1.tscn")
	
func _on_timer_timeout():
	Scroll.play("introscroll")
	timer.queue_free()
	pass

func _on_soundtimer_timeout():
	Noise.play()
	soundtimer.queue_free()

func _on_nutimer_timeout():
	nutimer.queue_free()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			FadeOut.play("FadeOut")
		flag = true
