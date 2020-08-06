extends RigidBody

var dir
onready var TweenNode = get_node("Tween")
onready var Smoked = get_node("Armature003/Skeleton/Cube009/CPUParticles")
onready var DeathRattle = get_node("AudioStreamPlayer3D")
var timer
var timerducken
signal rathit

#copied from sheep code
func _ready():
	get_node("AnimationPlayer").play("MiceBWalkin")
#	pass

#upcoming func here: spawning in
#rats go down a spline/thingy so they are on correct level. perhaops they come out of a hole
#
#


func _on_Area_body_entered(body):
	#ram headbutt signal
	emit_signal("rathit")
	#the usual
	var dir = Vector3(sign(global_transform.origin.x - body.global_transform.origin.x), 1, sign(global_transform.origin.z - body.global_transform.origin.z))
	apply_central_impulse(dir * 5)
	apply_torque_impulse(dir)
	#now comes the death effects
	Smoked.set_emitting(true)
	#sound
	if DeathRattle.is_playing() == false:
		DeathRattle.play()
	#sound done
	get_node("AnimationPlayer").play("MiceCurled")
	TweenNode.interpolate_property(self, "scale", null,  Vector3(3,3,3), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	TweenNode.start()
	#finally, the rat will disappear and die
	timer = Timer.new()
	timer.set_wait_time(1.0)
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer) #to process
	timer.start() #to start
	
	# disable collisions
	get_node("Area/CollisionShape2").disabled = true
	get_node("CollisionShape").disabled = true
	
	pass # Replace with function body.

func _on_timer_timeout():
	TweenNode.interpolate_property(self, "scale", null,  Vector3(50,0,0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	TweenNode.start()
	timerducken = Timer.new()
	timerducken.set_wait_time(1.0)
	timerducken.connect("timeout",self,"_on_timerducken_timeout") 
	add_child(timerducken)
	timerducken.start()
	
func _on_timerducken_timeout():
	queue_free()

func _physics_process(delta):
	add_central_force(Vector3(0,0,1.5)) #too fast + accelerates. but it works better than the alternative
#	translation.z += 0.1 #this makes the butting not work
	pass
