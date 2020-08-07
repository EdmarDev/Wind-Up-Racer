extends Camera

var target: Vehicle
var max_distance := 5
var _warp_pos: Vector3
var _target_fell := false

func _ready() -> void:
	target = get_node("../Player")
	look_at(target.global_transform.origin + Vector3.UP * 1.5 , Vector3.UP)
	target.connect("fell", self, "_on_target_fell")
	


func _physics_process(delta: float) -> void:
	var target_pos := target.global_transform.origin
	var self_pos := global_transform.origin
	look_at(target_pos + Vector3.UP * 1.5, Vector3.UP)
	if _target_fell:
		return
	
	target_pos.y = 0
	self_pos.y = 0
	if self_pos.distance_to(target_pos) > max_distance:
		var future_pos := target_pos - (target_pos - self_pos).normalized() * max_distance
		future_pos.y = target.global_transform.origin.y + 2.5
		global_transform.origin = future_pos


func _on_target_fell():
	_target_fell = true
