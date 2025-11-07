extends Resource
class_name Task


@export var display_name: String


func _to_string() -> String:
	return "<Task:%s>" % display_name
