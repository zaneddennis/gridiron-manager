extends RefCounted
class_name SimulationPlayer


const DEFAULT_ACTION = "default_action"


# inputs
var player: Player
var role: LineupInstruction.ROLE
var assignment: Play.ASSIGNMENT
var display_char: String

# status
var position: Vector2  # yards
var has_ball: bool = false
var action: String = ""


func _init(p: Player, li: LineupInstruction) -> void:
	player = p
	role = li.role
	position = li.GetAbsolutePos()
	display_char = li.GetDisplayChar()


func DecideAction(time: float = 0.0):
	#print("\t\t\t\t\tAssignment: ", Play.ASSIGNMENT.keys()[assignment])
	if role in [LineupInstruction.ROLE.QBU, LineupInstruction.ROLE.QBS]:
		action = "receive_snap"
	else:
		action = "default_action"


func _receive_snap():
	print("\t\t\t\t\tReceive snap")
	has_ball = true


func _to_string() -> String:
	return "<SimulationPlayer:%s:%s>" % [player, LineupInstruction.ROLE.keys()[role]]
