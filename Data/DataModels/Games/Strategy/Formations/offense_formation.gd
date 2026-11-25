extends Formation
class_name OffenseFormation


var personnel: String = ""


func _init(n: String, p: String) -> void:
	super(n)
	
	personnel = p


func _to_string() -> String:
	return "<OffenseFormation:%s>" % name
