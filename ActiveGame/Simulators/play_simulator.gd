extends RefCounted
class_name PlaySimulator


var off_players: Array[SimulationPlayer]
var def_players: Array[SimulationPlayer]


static func SimulatePlay(gs: GameSimulator, off_play: OffensePlay, def_play: DefensePlay) -> PlayResult:
	var ps = PlaySimulator.new(
		gs,
		off_play.GetLineup(gs.depth_charts[gs.offense]),
		def_play.GetLineup(gs.depth_charts[int(!gs.offense)])
	)
	
	var desc = "Offense Play: %s\nDefense Play: %s\n" % [
		off_play.name, def_play.name
	]
	
	if off_play is RunPlay:
		return ps.SimulateRun(off_play, def_play, desc)
	else:  # TODO: elif PassPlay
		return ps.SimulatePass(off_play, def_play, desc)


func _init(gs: GameSimulator, op: Array[SimulationPlayer], dp: Array[SimulationPlayer]) -> void:
	off_players = op
	def_players = dp


func SimulateRun(off_play: RunPlay, def_play: DefensePlay, desc: String) -> PlayResult:
	# gap blocking
	_sim_run_block(
		off_play.gap,
		{},  # blocking players: proximity  TODO: HERE
		{}  # defending players: proximity
	)
	
	# runner in gap
	
	# runner next level
	
	# runner open field
	
	var yards = randi_range(0, 8)
	
	return PlayResult.new(
		off_play,
		def_play,
		yards,
		randi_range(5, 10),  # seconds elasped during play
		desc + "[RB] rushes for %d yards. Tackled by [defender]" % yards
	)

func SimulatePass(off_play: OffensePlay, def_play: DefensePlay, desc: String) -> PlayResult:
	var yards = 0
	if randf() < 0.05:
		yards = randi_range(-6, -2)  # sack
		desc += "[QB] sacked for %d yards." % yards
	elif randf() < 0.6:  # complete pass
		yards = randi_range(4, 20)
		desc += "[QB] passes to [target]. Complete for %d yards." % yards
	else:
		desc += "[QB] passes to [target]. Incomplete."
	
	return PlayResult.new(
		off_play,
		def_play,
		yards,  # yards gained
		randi_range(5, 10),  # seconds elasped during play
		desc
	)


func _sim_run_block(
	gap: LineupInstruction.GAP,
	blocking_players: Dictionary,  # all blocking offensive players and their proximity to the gap
	defending_players: Dictionary  # all defenders and their proximity to the gap
):
	var blocking: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]  # dice roll of each blocker
	var defending: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]  # dice roll of each defender
	
	return []  # list of defense danger to ballcarrier (proximity + openness)

# TODO: _sim_run_block_zone
