extends Area

func _ready() -> void:
	pass # Replace with function body.


func _on_SpeedBoost_body_entered(body: Node) -> void:
	if not (body is Vehicle):
		return
	var vehicle := body as Vehicle
	vehicle.recover_energy(1.5)
	vehicle.add_boost(15, .5)
	queue_free()
