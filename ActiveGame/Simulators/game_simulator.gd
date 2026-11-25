extends RefCounted
class_name GameSimulator


var default_strategy: Strategy


var verbose: bool


enum SIDE{AWAY, HOME}

var game: Game
var teams: Array[Team]
#var rosters: Dictionary[SIDE, Array]  # Array[Player]
var depth_charts: Dictionary[SIDE, DepthChart]

var quarter: int = 1
var clock: int = 15 * 60  # seconds remaining in quarter
var ball_on: int = 25  # [0, 100]
var down: int = 1
var to_go: int = 10  # TODO: handle goal-to-go
var offense: SIDE

#var players_on_field: Dictionary[SIDE, Array]  # Array[Player]

var away_score: int = 0
var home_score: int = 0
var coin: SIDE


func _init(g: Game, v: bool = false) -> void:
	game = g
	teams = [g.away_team, g.home_team]
	#rosters = {
	#	SIDE.AWAY: g.away_team.GetRoster(),
	#	SIDE.HOME: g.home_team.GetRoster()
	#}
	#print("GS NEW Teams:")
	#print(teams)
	depth_charts = {
		SIDE.AWAY: g.away_team.GetDepthChart(),
		SIDE.HOME: g.home_team.GetDepthChart()
	}
	#print("GS NEW Depth Charts:")
	#print(depth_charts)
	
	verbose = v
	
	default_strategy = Strategy.new()


func _printv(s: String):
	if verbose:
		print(s)


func StartGame():
	#coin = SIDE.values().pick_random()
	coin = SIDE.AWAY
	_printv("\tCoin Toss: %s kicks" % SIDE.keys()[coin])
	offense = coin
	
	_kickoff()


func UpdateQuarters():
	if clock <= 0:
		if quarter <= 3:
			clock = 15 * 60
			quarter += 1
			
			if quarter == 3:  # halftime
				offense = coin
				_turnover()
				_kickoff()
		elif quarter == 4:
			return "END"
		else:
			assert(false)  # TODO: overtime


func SimulatePlay(off_play: OffensePlay, def_play: DefensePlay) -> PlayResult:
	@warning_ignore("integer_division")
	_printv("\t[%d:%d | Q%d | %d&%d | Ball on %d | %d:%d]" % [
		clock/60, clock % 60,
		quarter, down, to_go, ball_on,
		away_score, home_score
	])
	
	_printv("\t\tOffense Play: %s" % off_play)
	_printv("\t\tDefense Play: %s" % def_play)
	
	# TODO: substitutions
	
	var result = PlaySimulator.SimulatePlay(self, off_play, def_play)
	result.seconds += randi_range(20, 30)  # seconds between plays
	
	_printv("\t\tPlay Result: %d yards" % result.yards)
	ball_on += result.yards
	clock -= result.seconds
	
	if ball_on >= 100:
		_printv("\t\tTOUCHDOWN")
		_touchdown()
	
	elif result.yards >= to_go:
		_printv("\t\tFirst Down")
		down = 1
		to_go = 10
	
	else:
		if down == 4:
			_printv("\t\tTurnover on Downs")
			_turnover()
			ball_on = 100 - ball_on
		else:
			down += 1
			to_go -= result.yards
	
	return result


func SimulateGame():
	_printv("Simulating Game")
	StartGame()
	
	while true:
		if UpdateQuarters() == "END":
			break
		else:
			var playcalls = _call_plays()
			SimulatePlay(playcalls[0], playcalls[1])


func _call_plays():
	var off_play: OffensePlay = default_strategy.PickOffensePlay()
	var def_play: DefensePlay = default_strategy.PickDefensePlay()
	return [off_play, def_play]


# set which players are on the field based on the playcall
#func _do_substitutions(s: SIDE):
#	players_on_field[s] = []


#func _simulate_play(off_play: OffensePlay, def_play: DefensePlay) -> PlayResult:
#	var result = PlaySimulator.SimulatePlay(self, off_play, def_play)
#	result.seconds += randi_range(20, 30)  # seconds between plays
#	
#	return result


func _score_points(s: SIDE, p: int):
	match s:
		SIDE.AWAY:
			away_score += p
		SIDE.HOME:
			home_score += p


func _turnover():
	if offense == SIDE.AWAY:
		offense = SIDE.HOME
	elif offense == SIDE.HOME:
		offense = SIDE.AWAY
	down = 1
	to_go = 10


func _kickoff():
	_turnover()
	ball_on = 25


func _touchdown():
	_score_points(offense, 7)
	_kickoff()
