extends RigidBody

var dir
#copied from sheep code
func _ready():
	get_node("AnimationPlayer").play("MiceBWalkin")
#	pass

func _on_Area_body_entered(body):
	var dir = Vector3(sign(global_transform.origin.x - body.global_transform.origin.x), 1, sign(global_transform.origin.z - body.global_transform.origin.z))
	apply_central_impulse(dir * 5)
	apply_torque_impulse(dir)
	#imer here for despawn
	pass # Replace with function body.

func _physics_process(delta):
	add_central_force(Vector3(0,0,1.5)) #too fast + accelerates. but it works better than the alternative
#	translation.z += 0.1 #this makes the butting not work
	pass
