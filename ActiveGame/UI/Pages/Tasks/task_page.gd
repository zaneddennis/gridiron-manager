extends Page
class_name TaskPage


signal task_completed(task_page: TaskPage)


@export var task: Task


func _ready() -> void:
	$Panel/ScrollBox/VBox/Title.text = task.display_name
