extends RigidBody

# fly away
func _on_Area_body_entered(body):
	var dir = Vector3(sign(global_transform.origin.x - body.global_transform.origin.x), 1, sign(global_transform.origin.z - body.global_transform.origin.z))
	apply_central_impulse(dir * 5)
	apply_torque_impulse(dir)

func _physics_process(delta):
	get_node("AnimationPlayer").play("default")
