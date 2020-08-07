class_name GearUI
extends TextureProgress

var _player: Vehicle

func initialize(player: Vehicle):
	_player = player
	max_value = _player.get_max_energy()


func _process(delta: float) -> void:
	if _player:
		value = _player.get_current_energy()
