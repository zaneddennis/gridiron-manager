extends RefCounted
class_name Strategy


# playbook
var offense_plays: Array[OffensePlay]
var defense_plays: Array[DefensePlay]


# TODO: move all this data to external files
func _init() -> void:
	# default strategy
	
	# offense formations
	var spread = OffenseFormation.new("Spread", "11")
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
			LineupInstruction.new(LineupInstruction.ROLE.TE, 1),
		DepthChartSlot.new(Player.POSITION.WR, 1):
			LineupInstruction.new(LineupInstruction.ROLE.WRX, 1),
		DepthChartSlot.new(Player.POSITION.WR, 2):
			LineupInstruction.new(LineupInstruction.ROLE.WRZ, 1),
		DepthChartSlot.new(Player.POSITION.WR, 3):
			LineupInstruction.new(LineupInstruction.ROLE.WRA, 1)
	} as Dictionary[DepthChartSlot, LineupInstruction]
	
	var i_formation = OffenseFormation.new("I-Formation", "21")
	i_formation.lineup = {
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
			LineupInstruction.new(LineupInstruction.ROLE.QBU),
		DepthChartSlot.new(Player.POSITION.RB, 1):
			LineupInstruction.new(LineupInstruction.ROLE.RBS),
		DepthChartSlot.new(Player.POSITION.RB, 2):
			LineupInstruction.new(LineupInstruction.ROLE.FB),
		DepthChartSlot.new(Player.POSITION.TE, 1):
			LineupInstruction.new(LineupInstruction.ROLE.TE, 1),
		DepthChartSlot.new(Player.POSITION.WR, 1):
			LineupInstruction.new(LineupInstruction.ROLE.WRX, 1),
		DepthChartSlot.new(Player.POSITION.WR, 2):
			LineupInstruction.new(LineupInstruction.ROLE.WRZ, 1),
	} as Dictionary[DepthChartSlot, LineupInstruction]
	
	var goal_line_o = OffenseFormation.new("Goal Line", "Jumbo")
	goal_line_o.lineup = {
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
			LineupInstruction.new(LineupInstruction.ROLE.QBU),
		DepthChartSlot.new(Player.POSITION.RB, 1):
			LineupInstruction.new(LineupInstruction.ROLE.RBS),
		DepthChartSlot.new(Player.POSITION.RB, 2):
			LineupInstruction.new(LineupInstruction.ROLE.FB),
		DepthChartSlot.new(Player.POSITION.TE, 1):
			LineupInstruction.new(LineupInstruction.ROLE.TE, 1),
		DepthChartSlot.new(Player.POSITION.TE, 2):
			LineupInstruction.new(LineupInstruction.ROLE.TE, -1),
		DepthChartSlot.new(Player.POSITION.WR, 1):
			LineupInstruction.new(LineupInstruction.ROLE.WRX, 1),
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
			DefenseLineupInstruction.new(LineupInstruction.ROLE.STAR, DefenseLineupInstruction.GAP.SPILL),
		DepthChartSlot.new(Player.POSITION.S, 2):
			DefenseLineupInstruction.new(LineupInstruction.ROLE.FS, DefenseLineupInstruction.GAP.ZERO)
	} as Dictionary[DepthChartSlot, LineupInstruction]
	
	offense_plays = [
		# Spread
		RunPlay.new("HB Dive", spread, 6, LineupInstruction.GAP.A),
		PassPlay.new("Quick Slants", spread,
			{
				8: PassPlay.ROUTE.SLANT,
				9: PassPlay.ROUTE.SLANT,
				10: PassPlay.ROUTE.SLANT
			} as Dictionary[int, PassPlay.ROUTE]
		),
		OffensePlay.new("4 Verts", spread),
		
		# I-Formation
		RunPlay.new(
			"HB Dive", i_formation, 6, LineupInstruction.GAP.A
		),
		
		# Goal Line
		RunPlay.new("QB Sneak", goal_line_o, 6, LineupInstruction.GAP.A),
	]
	
	var base = DefensePlay.new(
		"Base", _425,
	)
	
	defense_plays = [
		base
	]


func PickOffensePlay():
	return offense_plays[0]

func PickDefensePlay():
	return defense_plays[0]


func GetOffenseFormations() -> Dictionary:
	var formations = {}
	
	for p: OffensePlay in offense_plays:
		var f: OffenseFormation = p.formation
		if not f.personnel in formations:
			formations[f.personnel] = []
		
		if not f in formations[f.personnel]:
			formations[f.personnel].append(f)
	
	return formations

func GetDefenseFormations() -> Dictionary:
	var formations = {}
	
	for p: DefensePlay in defense_plays:
		var f: DefenseFormation = p.formation
		var personnel_tmp = "all"
		if not personnel_tmp in formations:
			formations[personnel_tmp] = []
		
		if not f in formations[personnel_tmp]:
			formations[personnel_tmp].append(f)
	
	return formations
