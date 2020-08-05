extends Area

func _ready() -> void:
	pass # Replace with function body.


func _on_SpeedBoost_body_entered(body: Node) -> void:
	if not (body is Vehicle):
		return
	var vehicle := body as Vehicle
	vehicle.acceleration_boost += 60
	vehicle.persistent_boost += 10
	vehicle.drifting += .05
