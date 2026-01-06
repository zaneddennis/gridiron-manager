extends Play
class_name OffensePlay


enum TYPE{RUN, PASS}
var type: TYPE


func _init(n: String, f: Formation, a: Array[ASSIGNMENT], t: TYPE) -> void:
	super(n, f, a)
	type = t


func _to_string() -> String:
	return "<OffensePlay:%s>" % name
