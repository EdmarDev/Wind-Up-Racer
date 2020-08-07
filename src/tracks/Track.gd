class_name Track
extends Spatial

signal lap_finished

onready var _finish_line := $FinishLine as FinishLine

func _ready():
	_finish_line.connect("crossed", self, "_on_finish_line_crossed")


func _on_finish_line_crossed():
	emit_signal("lap_finished")
