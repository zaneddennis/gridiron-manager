extends Page
class_name SystemPage


func _on_resume_pressed() -> void:
	Close()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")


func _on_desktop_pressed() -> void:
	get_tree().quit()
