class_name FinishLine
extends Area

signal crossed

var _wrong_way := false

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node):
	if body is Vehicle:
		var vehicle := body as Vehicle
		var vel := vehicle.get_velocity()
		var dot := vel.dot(-global_transform.basis.z) 
		if dot <= 0.0: # Check if the player is crossing in the right way
			if !_wrong_way:
				emit_signal("crossed")
			else:
				_wrong_way = false
		else:
			_wrong_way = true
