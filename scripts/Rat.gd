extends RigidBody

#Ambient Rat noise: for localizing of the Rats
#rat particles?
#Long Rat death noise(no loop), pitched randomly, while also being satisfying
#a meaty Hit noise
#rats go to the barn's exposed haybales and eat the hay

#screenshake - when ram is running, hitting
#Perhaps Ram should become FASTER upon hitting an enemy.

#perhaps they simply have some holes in the fence//////rats go down a spline/thingy so they are on correct level. perhaops they come out of a hole

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
	TweenNode.interpolate_property(self, "scale", null,  Vector3(3,3,3), 0.05, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	TweenNode.start()
								#the rat flashes a color. except, this does not work = set surface material needs arg 2, which is material, but i dont know how to give it to it. no error just crash
#	TweenNode.interpolate_property($Armature003/Skeleton/Cube009.set_surface_material(0, $Armature003/Skeleton/Cube009.material_override), "emission", null, Vector3(1,1,1), 0,05, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
#	TweenNode.start()
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
	TweenNode.interpolate_property(self, "scale", null,  Vector3(50,-1,-0.1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	TweenNode.start()
	timerducken = Timer.new()
	timerducken.set_wait_time(1.0)
	timerducken.connect("timeout",self,"_on_timerducken_timeout") 
	add_child(timerducken)
	timerducken.start()
	
func _on_timerducken_timeout():
	queue_free()

func _physics_process(_delta):
	add_central_force(Vector3(0,0,1.5)) #too fast + accelerates. but it works better than the alternative
#	translation.z += 0.1 #this makes the butting not work
	pass
