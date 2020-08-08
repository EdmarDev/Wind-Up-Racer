class_name Game
extends Node

var _laps := 0
var _is_game_over := false

onready var _track := $Track as Track
onready var _player := $Player as Vehicle
onready var _gear_ui := $GearUI as GearUI
onready var _lap_label := $LapLabel as Label
onready var _win_label := $WinLabel as Label
onready var _intro_label := $IntroLabel as Label
onready var _intro_label2 := $IntroLabel2 as Label

func _ready():
	_track.connect("lap_finished", self, "_on_lap_finished")
	_player.connect("fell", self, "_on_player_fell")
	_player.connect("stopped", self, "_on_player_stopped")
	_gear_ui.initialize(_player)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		set_process(false)
		_intro_label.hide()
		_intro_label2.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		for i in 4:
			_player.recover_energy(5.0)
			yield(get_tree().create_timer(.5), "timeout")
		yield(get_tree().create_timer(.2), "timeout")
		_player.start_moving()


func _on_lap_finished():
	_laps += 1
	_lap_label.text = str(_laps) + "/3"
	if _laps == 3:
		_win()


func _win():
	_win_label.show()
	_is_game_over = true
	_player.stop_moving()
	yield(get_tree().create_timer(5.0), "timeout")
	yield(get_tree(), "idle_frame")
	get_tree().reload_current_scene()


func _on_player_fell():
	_game_over()


func _on_player_stopped():
	_game_over()


func _game_over():
	if _is_game_over:
		return
	_is_game_over = true
	yield(get_tree().create_timer(2.5), "timeout")
	yield(get_tree(), "idle_frame")
	get_tree().reload_current_scene()
