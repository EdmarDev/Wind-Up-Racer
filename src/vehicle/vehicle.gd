class_name Vehicle
extends KinematicBody

var _wheel_base := 1.9
var _velocity: Vector3
var _acceleration :=  35
var _reverse_accel := 15
var _heading_direction: Vector3
var _steering_direction: float
var _steering_angle := 13
var _gravity := 15
var _friction := .9
var _drag := 0.06

func _ready() -> void:
	_heading_direction = -global_transform.basis.z


func _physics_process(delta: float) -> void:
	_steering_direction = 0
	if Input.is_action_pressed("steer_left"):
			_steering_direction += deg2rad(_steering_angle * delta)
	if Input.is_action_pressed("steer_right"):
			_steering_direction += -deg2rad(_steering_angle * delta)
	
	if is_on_floor():
		align_to_floor()
		var f := _friction
		
		if Input.is_action_pressed("accelerate"):
			_velocity += _acceleration * _heading_direction * delta;
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
	
	$drag.text = str(((_velocity * _velocity.length() * _drag * delta).length())/delta)
	_velocity -= _velocity * _velocity.length() * _drag * delta
	
	look_at(global_transform.origin + _heading_direction, Vector3.UP)
	
	_velocity.y -= _gravity * delta
	_velocity = move_and_slide(_velocity, Vector3.UP)
	$speed.text = str(_velocity.length())
	if _velocity.length() < .01:
		_velocity = Vector3.ZERO


func steering(delta):
	var rear_wheel = global_transform.origin - _heading_direction * _wheel_base/2
	var front_wheel = global_transform.origin + _heading_direction * _wheel_base/2
	rear_wheel += _velocity 
	front_wheel += _velocity.rotated(get_floor_normal(), _steering_direction)
	_heading_direction = (front_wheel - rear_wheel).normalized()
	var d := _heading_direction.dot(_velocity.normalized())
	if d > 0:
		var target_vel := _heading_direction * _velocity.length()
		_velocity = _velocity.linear_interpolate(target_vel, 21 * delta)
	else:
		_velocity =  -_heading_direction * _velocity.length()


func align_to_floor():
	var n := get_floor_normal()
	var normal_component := _heading_direction.dot(n) * n
	var floor_projection := _heading_direction - normal_component
	_heading_direction = floor_projection.normalized() * _heading_direction.length()
