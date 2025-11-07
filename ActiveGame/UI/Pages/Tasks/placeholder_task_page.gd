extends TaskPage
class_name PlaceholderTaskPage


func _on_button_pressed() -> void:
	task_completed.emit(self)
