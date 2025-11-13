extends Node
# global TaskScheduler


@export var placeholder: Task

@export var medical: Task
@export var recruiting: Task
@export var scouting: Task
@export var gameplan: Task
@export var practice: Task
@export var gameday: Task

@export var conference_champions: Task


@onready var TASKS = {
	Timestamp.PHASE.PRESEASON: [
		medical, recruiting, practice
	],
	Timestamp.PHASE.REGULAR_SEASON: [
		medical, recruiting, scouting, gameplan, practice, gameday
	],
	Timestamp.PHASE.POSTSEASON: []
}


func GetTasks(date: Timestamp) -> Array[Task]:
	var tasks: Array[Task]
	tasks.assign(TASKS[date.phase])
	
	# if last week of regular season, add Crown Conference Champions Task
	if date.week >= Timestamp.PHASE_LENGTH[Timestamp.PHASE.REGULAR_SEASON]:
		tasks.append(conference_champions)
	
	return tasks
