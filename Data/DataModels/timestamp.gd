extends RefCounted
class_name Timestamp


enum PHASE{PRESEASON, REGULAR_SEASON, POSTSEASON}


const PHASE_LENGTH = {
	PHASE.PRESEASON: 2,
	PHASE.REGULAR_SEASON: 15,
	PHASE.POSTSEASON: 2
}


var year: int
var phase: PHASE
var week: int
var task: int


func _init(y: int, p: PHASE, w: int, t: int) -> void:
	year = y
	phase = p
	week = w
	task = t

static func FromISO(iso: String) -> Timestamp:
	return Timestamp.new(
		int(iso.split("-")[0]),
		int(iso.split("-")[1]),
		int(iso.split("-")[2]),
		int(iso.split("-")[3])
	)


func ToISO() -> String:
	return "%d-%d-%d-%d" % [year, phase, week, task]


func _to_string() -> String:
	return "<Timestamp:%d:%s:Week%d:Task%d>" % [year, PHASE.keys()[phase], week, task]
