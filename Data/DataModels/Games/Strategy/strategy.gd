extends RefCounted
class_name Strategy


# playbook
var offense_plays: Array[OffensePlay]
var defense_plays: Array[DefensePlay]


# TODO: move all this data to external files
func _init() -> void:
	# default strategy
	
	# offense formations
	var spread = OffenseFormation.new("Spread")
	spread.lineup = {
		DepthChartSlot.new(Player.POSITION.C, 1):
			LineupInstruction.new(LineupInstruction.ROLE.C),
		DepthChartSlot.new(Player.POSITION.OG, 1):
			LineupInstruction.new(LineupInstruction.ROLE.OG, -1),
		DepthChartSlot.new(Player.POSITION.OG, 2):
			LineupInstruction.new(LineupInstruction.ROLE.OG, 1),
		DepthChartSlot.new(Player.POSITION.OT, 1):
			LineupInstruction.new(LineupInstruction.ROLE.OT, -1),
		DepthChartSlot.new(Player.POSITION.OT, 2):
			LineupInstruction.new(LineupInstruction.ROLE.OT, 1),
		DepthChartSlot.new(Player.POSITION.QB, 1):
			LineupInstruction.new(LineupInstruction.ROLE.QBS),
		DepthChartSlot.new(Player.POSITION.RB, 1):
			LineupInstruction.new(LineupInstruction.ROLE.RBS, -1),
		DepthChartSlot.new(Player.POSITION.TE, 1):
			LineupInstruction.new(LineupInstruction.ROLE.TE, 1)
	} as Dictionary[DepthChartSlot, LineupInstruction]
	
	# defense formations
	var _425 = DefenseFormation.new("4-2-5 Nickel")
	_425.lineup = {
		DepthChartSlot.new(Player.POSITION.DT, 1):
			DefenseLineupInstruction.new(LineupInstruction.ROLE.DTS, DefenseLineupInstruction.GAP.B),
		DepthChartSlot.new(Player.POSITION.DT, 2):
			DefenseLineupInstruction.new(LineupInstruction.ROLE.DTW, DefenseLineupInstruction.GAP.A),
		DepthChartSlot.new(Player.POSITION.EDGE, 1):
			DefenseLineupInstruction.new(LineupInstruction.ROLE.DES, DefenseLineupInstruction.GAP.C),
		DepthChartSlot.new(Player.POSITION.EDGE, 2):
			DefenseLineupInstruction.new(LineupInstruction.ROLE.DEW, DefenseLineupInstruction.GAP.C),
		DepthChartSlot.new(Player.POSITION.LB, 1):
			DefenseLineupInstruction.new(LineupInstruction.ROLE.SAM, DefenseLineupInstruction.GAP.A),
		DepthChartSlot.new(Player.POSITION.LB, 2):
			DefenseLineupInstruction.new(LineupInstruction.ROLE.WILL, DefenseLineupInstruction.GAP.B),
		DepthChartSlot.new(Player.POSITION.S, 1):
			DefenseLineupInstruction.new(LineupInstruction.ROLE.STAR, DefenseLineupInstruction.GAP.H),
		DepthChartSlot.new(Player.POSITION.S, 2):
			DefenseLineupInstruction.new(LineupInstruction.ROLE.FS, DefenseLineupInstruction.GAP.BALL)
	} as Dictionary[DepthChartSlot, LineupInstruction]
	
	var hb_zone = OffensePlay.new(
		"HB Zone", spread,
		[
			Play.ASSIGNMENT.ZONE_BLOCK,
			Play.ASSIGNMENT.ZONE_BLOCK,
			Play.ASSIGNMENT.ZONE_BLOCK,
			Play.ASSIGNMENT.ZONE_BLOCK,
			Play.ASSIGNMENT.ZONE_BLOCK,
			Play.ASSIGNMENT.HANDOFF,
			Play.ASSIGNMENT.RUN_INSIDE_ZONE,
			Play.ASSIGNMENT.ZONE_BLOCK
		],
		OffensePlay.TYPE.RUN
	)
	var hb_dive = OffensePlay.new(
		"HB Dive", spread,
		[],
		OffensePlay.TYPE.RUN,
	)
	#var quick_slants = PassPlay.new("Quick Slants")
	
	offense_plays = [
		hb_zone, hb_dive
	]
	
	var base = DefensePlay.new(
		"Base", _425,
		[
			Play.ASSIGNMENT.RUSH,
			Play.ASSIGNMENT.RUSH,
			Play.ASSIGNMENT.RUSH,
			Play.ASSIGNMENT.RUSH,
			Play.ASSIGNMENT.RUSH,
			Play.ASSIGNMENT.RUSH,
			Play.ASSIGNMENT.RUSH,
			Play.ASSIGNMENT.COVER_1
		]
	)
	#var soft_zone = DefensePlay.new("Soft Zone", _425)
	#var press = DefensePlay.new("Press Coverage", _425)
	#var blitz = DefensePlay.new("Blitz", _425)
	
	defense_plays = [
		base#, soft_zone, press, blitz
	]


#func GetOffensePersonnels() -> Array[OffensePersonnel]:
#	return [
#		OffensePersonnel.new(0, 0),
#		OffensePersonnel.new(1, 0),
#		OffensePersonnel.new(1, 1)
#	]


func PickOffensePlay():
	return offense_plays[0]

func PickDefensePlay():
	return defense_plays[0]
