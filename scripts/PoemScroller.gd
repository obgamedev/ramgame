extends Spatial

onready var Poetry = $AnimationPlayer
onready var FadeOut = $AnimationPlayer2
onready var Noise = $AudioStreamPlayer
var timer
var nutimer
var soundtimer
signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.set_wait_time(0.5)
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer) #to process
	timer.start() #to start
	#timer 2
	nutimer = Timer.new()
	nutimer.set_wait_time(5)
	nutimer.connect("timeout",self,"_on_nutimer_timeout") 
	add_child(nutimer) #to process
	nutimer.start() #to start
	soundtimer = Timer.new()
	soundtimer.set_wait_time(0.4)
	soundtimer.connect("timeout",self,"_on_soundtimer_timeout") 
	add_child(soundtimer) #to process
	soundtimer.start() #to start
	soundtimer.emit_signal("finished", self)

func _on_timer_timeout():
	Poetry.play("PoemScroll")
	timer.queue_free()
	pass

func _on_soundtimer_timeout():
	Noise.play()
	soundtimer.queue_free()

func _on_nutimer_timeout():
	FadeOut.play("FadeOut")
	nutimer.queue_free()
#
#func _on_AudioStreamPlayer_finished():
#	Noise.volume_db(0)
#	pass # Replace with function body.
