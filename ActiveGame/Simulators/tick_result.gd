extends RefCounted
class_name TickResult

# position and status of ball?
# position, status, and action of each player

var start_time: float = 0.0


func _init(t: float) -> void:
	start_time = t


func _to_string() -> String:
	return "<TickResult>"
