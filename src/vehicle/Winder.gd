class_name Winder
extends MeshInstance

enum WinderState {
	STOPPED,
	UNWIND,
	WIND_UP
}

var _current_state = WinderState.STOPPED
var _default_rotation_speed := -60.0
var _current_rotation := 0.0
var _hold := true

onready var _tween := $Tween as Tween

func _ready():
	_tween.connect("tween_all_completed", self, "_on_tween_finished")


func _process(delta: float) -> void:
	if _current_state == WinderState.UNWIND:
		_set_rotation(_current_rotation + _default_rotation_speed * delta)


func spin(duration: float):
	_tween.interpolate_method(self, "_set_rotation", _current_rotation, 
			_current_rotation + 360, duration, Tween.TRANS_CIRC, Tween.EASE_OUT)
	_tween.start()
	_current_state = WinderState.WIND_UP


func unwind():
	_current_state = WinderState.UNWIND
	_hold = false


func stop():
	_current_state = WinderState.STOPPED


func _set_rotation(rot: float):
	_current_rotation = wrapf(rot, 0, 360)
	transform.basis = Basis()
	rotate_z(deg2rad(_current_rotation))


func _on_tween_finished():
	if not _hold:
		_current_state = WinderState.UNWIND
