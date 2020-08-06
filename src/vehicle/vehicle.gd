class_name Vehicle
extends KinematicBody

signal warp_set
signal warped

var acceleration_boost := 0.0
var persistent_boost := 0.0
var drifting := .1
var persistent_boost_min_speed := 15.0
var _boost_decay := 45.0
var _wheel_base := 1.9
var _velocity: Vector3
var _acceleration :=  35.0
var _reverse_accel := 15.0
var _heading_direction: Vector3
var _steering_direction: float
var _steering_angle := 9
var _gravity := 15.0
var _friction := .9
var _drag := 0.06

var _is_on_floor := false
var _floor_normal := Vector3.UP
var _look_dir := Vector3.ZERO

var _warp_position: Vector3
var _warp_active := false
var _warp_heading: Vector3

func _ready() -> void:
	_heading_direction = -global_transform.basis.z
	_look_dir = _heading_direction


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("warp"):
		if _warp_active:
			_warp()
		else:
			_setup_warp()


func _physics_process(delta: float) -> void:
	_steering_direction = 0
	if Input.is_action_pressed("steer_left"):
			_steering_direction += deg2rad(_steering_angle * delta)
	if Input.is_action_pressed("steer_right"):
			_steering_direction += -deg2rad(_steering_angle * delta)
	
	if _is_on_floor:
		var f := _friction
		_update_acceleration(delta)
		if Input.is_action_pressed("accelerate"):
			_velocity += get_final_acceleration() * _heading_direction * delta;
		elif Input.is_action_pressed("reverse"):
			_velocity -= _reverse_accel * _heading_direction * delta;
		if Input.is_action_pressed("brake"):
			f += 3.0
			_steering_direction *= 2.5
		
		steering(delta)
	
		f *= delta
		if _velocity.length() < 2:
			f *= 3
		$friction.text = str(((_velocity * f).length())/delta)
		_velocity -= _velocity * f
	
		$drag.text = str(_is_on_floor)#str(((_velocity * _velocity.length() * _drag * delta).length())/delta)
		_velocity -= _velocity * _velocity.length() * _drag * delta
	
	_look_dir = _look_dir.move_toward(_heading_direction, 2.0 * delta)
	look_at(global_transform.origin + _look_dir, Vector3.UP)
	
	_velocity.y -= _gravity * delta
	apply_movement(delta)


func get_final_acceleration() -> float:
	return persistent_boost + acceleration_boost + _acceleration


func _update_acceleration(delta: float):
	acceleration_boost = max(0, acceleration_boost - _boost_decay * delta)
	if _velocity.length() <= persistent_boost_min_speed:
		_reset_persistent_boost()


func _reset_persistent_boost():
	persistent_boost = 0
	persistent_boost_min_speed = 15
	drifting = .1


func steering(delta: float):
	var rear_wheel := global_transform.origin - _heading_direction * _wheel_base/2
	var front_wheel := global_transform.origin + _heading_direction * _wheel_base/2
	rear_wheel += _velocity 
	front_wheel += _velocity.rotated(_floor_normal, _steering_direction)
	_heading_direction = (front_wheel - rear_wheel).normalized()
	var d := _heading_direction.dot(_velocity.normalized())
	if d > 0:
		var target_vel := _heading_direction * _velocity.length()
		_velocity = _velocity.linear_interpolate(target_vel, (1/drifting) * delta)
	else:
		_velocity =  -_heading_direction * _velocity.length()


func align_to_floor():
	var n := _floor_normal
	var normal_component := _heading_direction.dot(n) * n
	var floor_projection := _heading_direction - normal_component
	_heading_direction = floor_projection.normalized() * _heading_direction.length()


func apply_movement(delta: float):
#	_velocity = move_and_slide(_velocity, Vector3.UP)
#	for i in get_slide_count():
#		var col := get_slide_collision(i)
#		var angle := rad2deg(col.normal.angle_to(Vector3.UP))
#		if angle >= 45:
#			_velocity += col.normal * 10
#			_reset_persistent_boost()
#			break
	$speed.text = str(_velocity.length())

	_is_on_floor = false
	var delta_vel := _velocity * delta
	var col := move_and_collide(delta_vel)
	var i := 0
	while col and i < 4:
		i += 1
		var remainder := col.remainder
		var n := col.normal
		var angle := rad2deg(col.normal.angle_to(Vector3.UP))
		var is_wall := angle > 65
		if !is_wall :
			_velocity = _velocity.slide(n)
			delta_vel = remainder.slide(n)
			_is_on_floor = true
			_floor_normal = n
			align_to_floor()
		else:
			_velocity = _velocity.bounce(n)
			if _velocity.length() > 10:
				_velocity = _velocity.normalized() * 10
			delta_vel = remainder.bounce(n)
		col = move_and_collide(delta_vel)


func _warp():
	translation = _warp_position
	_warp_active = false
	_heading_direction = _warp_heading
	_velocity = _heading_direction.normalized() * _velocity.length()
	look_at(global_transform.origin + _heading_direction, Vector3.UP)
	_look_dir = _heading_direction
	emit_signal("warped")


func _setup_warp():
	_warp_position = translation
	_warp_active = true
	_warp_heading = _heading_direction
	emit_signal("warp_set")
