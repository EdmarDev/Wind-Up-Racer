class_name Wheel
extends MeshInstance

export var _rotation_speed := 360.0
var _vehicle: Vehicle

func _ready() -> void:
	_vehicle = owner as Vehicle


func _process(delta: float) -> void:
	if _vehicle.is_moving():
		rotate_x(deg2rad(_rotation_speed) * delta)
