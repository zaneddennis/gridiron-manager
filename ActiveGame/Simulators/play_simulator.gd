extends RefCounted
class_name PlaySimulator


const TICK_LENGTH = 0.5
var time: float = 0.0

var off_players: Array[SimulationPlayer]
var def_players: Array[SimulationPlayer]


func _init(gs: GameSimulator, off_play: OffensePlay, def_play: DefensePlay) -> void:
	off_players = off_play.GetLineup(gs.depth_charts[gs.offense])
	def_players = def_play.GetLineup(gs.depth_charts[int(!bool(int(gs.offense)))])
	
	for i in range(len(off_players)):
		var sp = off_players[i]
		var a = off_play.assignments[i]
		sp.assignment = a
		
		sp = def_players[i]
		a = def_play.assignments[i]
		sp.assignment = a
	
	time = 0.0


func SimulatePlay() -> Array[TickResult]:
	print("\t\tSimulating Play")
	
	# lineups
		# who is on the field and where are they?
	print("\t\tLineups:")
	print("\t\t\t", off_players)
	print("\t\t\t", def_players)
	
	# assignments
	print("\t\tAssignments:")
	print("\t\t\t", off_players.map(func(sp: SimulationPlayer): return Play.ASSIGNMENT.keys()[sp.assignment]))
	print("\t\t\t", def_players.map(func(sp: SimulationPlayer): return Play.ASSIGNMENT.keys()[sp.assignment]))
	
	# ticks
	var ticks: Array[TickResult] = []
	while true:
		print("\t\tTICK %.2f" % time)
		ticks.append(Tick())
		
		time += TICK_LENGTH
		
		if time >= 2.0:
			break
	
	#return [TickResult.new(time), TickResult.new(time), TickResult.new(time)]
	return ticks


func Tick() -> TickResult:
		
	# decide actions
	for sp: SimulationPlayer in off_players:
		sp.DecideAction()
	
	# execute actions
	for sp: SimulationPlayer in off_players:
		print("\t\t\t\t%s %s%s" % [sp, sp.action, " *" if sp.has_ball else ""])
		if sp.action != sp.DEFAULT_ACTION:
			sp.call("_" + sp.action)
	
	# resolve contests
	
	return TickResult.new(time)
