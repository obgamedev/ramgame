extends MeshInstance

var MAX_HEALTH = 100
var health = MAX_HEALTH
var damagePerRat = 2

onready var healthBar = get_node("TextureRect/HealthBar")

func _on_Area_body_entered(body):
	if !body.is_in_group("rat") :
		return
	health = max(0, health - damagePerRat)
	body.queue_free()

func _process(delta):
	healthBar.set_value(health)
	var r = range_lerp(health, 10, 100, 1, 0)
	var g = range_lerp(health, 10, 100, 0, 1)
	var styleBox = healthBar.get("custom_styles/fg")
	styleBox.bg_color = Color(r, g / 2, 0)
