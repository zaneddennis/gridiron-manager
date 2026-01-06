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
var to_go: int = 10
var offense: SIDE

var players_on_field: Dictionary[SIDE, Array]  # Array[Player]

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
	depth_charts = {
		SIDE.AWAY: g.away_team.GetDepthChart(),
		SIDE.HOME: g.home_team.GetDepthChart()
	}
	
	verbose = v
	
	default_strategy = Strategy.new()


func _printv(s: String):
	if verbose:
		print(s)


func Simulate():
	_printv("Simulating Game")
	
	coin = SIDE.values().pick_random()
	_printv("\tCoin Toss: %s kicks" % SIDE.keys()[coin])
	offense = coin
	
	_kickoff()
	
	# drives
	while true:
		if clock <= 0:
			if quarter <= 3:
				clock = 15 * 60
				quarter += 1
				
				if quarter == 3:  # halftime
					offense = coin
					_turnover()
					_kickoff()  # this is janky as hell but it works
			elif quarter == 4:
				break  # end of game
			else:
				assert(false)  # TODO: overtime
		
		@warning_ignore("integer_division")
		_printv("\t[%d:%d | Q%d | %d&%d | Ball on %d | %d:%d]" % [
			clock/60, clock % 60,
			quarter, down, to_go, ball_on,
			away_score, home_score
		])
		
		var p = _call_plays()
		var off_play = p[0]
		var def_play = p[1]
		
		# substitutions
		
		var result = _simulate_play(off_play, def_play)
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
		
		break


func _call_plays():
	_printv("\t\tOffense Team: %s" % SIDE.keys()[offense])
	
	# offense play
	var play: OffensePlay = default_strategy.PickOffensePlay()
	_printv("\t\tOffense Play: %s" % play)
	
	# defense play
	var def_play: DefensePlay = default_strategy.PickDefensePlay()
	_printv("\t\tDefense Play: %s" % def_play)
	
	return [play, def_play]


# set which players are on the field based on the playcall
func _do_substitutions(s: SIDE):
	players_on_field[s] = []


func _simulate_play(play: OffensePlay, def_play: DefensePlay) -> PlayResult:
	var ps = PlaySimulator.new(self, play, def_play)
	ps.SimulatePlay()
	
	var result = PlayResult.new(
		randi_range(-3, 12),  # yards gained
		randi_range(5, 10)  # seconds elasped during play
	)
	result.seconds += randi_range(20, 30)  # seconds between plays
	
	return result


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
