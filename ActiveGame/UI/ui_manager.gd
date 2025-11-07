extends CanvasLayer
class_name UIManager


@export var ag: ActiveGame


func _ready() -> void:
	for b: Button in $VBox/PageButtons.get_children():
		b.pressed.connect(_on_pagebutton_pressed.bind(b.name))


func Refresh():
	#$Background.color = ag.GetUserSchool().colors[0]
	
	var timestamp = ag.current_date
	$VBox/TopBar/Timestamp.text = "%d - %s - Week %d" % [
		timestamp.year, timestamp.PHASE.keys()[timestamp.phase].capitalize(), timestamp.week
	]


func _on_pagebutton_pressed(page_name: String):
	var page: Page = $VBox/Pages.get_node(page_name)
	if page.visible:
		page.Close()
	else:
		page.Activate(ag)

func _on_system_pressed() -> void:
	$VBox/Pages/System.Activate(ag)
