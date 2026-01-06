extends RefCounted
class_name Play


enum ASSIGNMENT {
	# OL
	ZONE_BLOCK,
	
	# QB
	HANDOFF,
	
	# RB
	RUN_INSIDE_ZONE, RUN_OUTSIDE_ZONE,
	
	# DEFENSE
	RUSH,
	COVER_1
}


var name: String
var formation: Formation
var assignments: Array[ASSIGNMENT]

func _init(n: String, f: Formation, a: Array[ASSIGNMENT]) -> void:
	name = n
	formation = f
	assignments = a


# what players are on the field when this play is run
func GetLineup(depth_chart: DepthChart) -> Array[SimulationPlayer]:
	var result = [] as Array[SimulationPlayer]
	for slot: DepthChartSlot in formation.lineup:
		var li: LineupInstruction = formation.lineup[slot]
		result.append(
			SimulationPlayer.new(depth_chart.GetPlayer(slot), li)
		)
	
	return result
