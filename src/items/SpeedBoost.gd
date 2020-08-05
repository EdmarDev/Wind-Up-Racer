extends Area

func _ready() -> void:
	pass # Replace with function body.


func _on_SpeedBoost_body_entered(body: Node) -> void:
	if not (body is Vehicle):
		return
	var vehicle := body as Vehicle
	vehicle.acceleration_boost += 45
	vehicle.persistent_boost += 4
	vehicle.persistent_boost_min_speed += .6
	vehicle.drifting += .05
