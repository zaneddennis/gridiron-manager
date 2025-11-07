extends Node
# global TaskScheduler


@export var placeholder: Task
@export var medical: Task
@export var recruiting: Task
@export var scouting: Task
@export var gameplan: Task
@export var practice: Task
@export var gameday: Task


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
	return tasks
