extends RigidBody

var dir
onready var TweenNode = get_node("Tween")
onready var Smoked = get_node("Armature003/Skeleton/Cube009/CPUParticles")
#copied from sheep code
func _ready():
	get_node("AnimationPlayer").play("MiceBWalkin")
#	pass

func _on_Area_body_entered(body):
	var dir = Vector3(sign(global_transform.origin.x - body.global_transform.origin.x), 1, sign(global_transform.origin.z - body.global_transform.origin.z))
	apply_central_impulse(dir * 5)
	apply_torque_impulse(dir)
	get_node("AnimationPlayer").play("MiceCurled")
	TweenNode.interpolate_property(self, "scale", null,  Vector3(3,3,3), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	TweenNode.start()
#	timer here pls
#	TweenNode.interpolate_property(self, "scale", null,  Vector3(0,0,0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
#	TweenNode.start()
	Smoked.set_emitting(true)
	#sound
	#imer here for despawn
	pass # Replace with function body.

func _physics_process(delta):
	add_central_force(Vector3(0,0,1.5)) #too fast + accelerates. but it works better than the alternative
#	translation.z += 0.1 #this makes the butting not work
	pass
