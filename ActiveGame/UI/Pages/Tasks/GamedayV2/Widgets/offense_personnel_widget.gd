extends HBoxContainer


signal personnel_selected(op: OffensePersonnel)


func Clear():
	for n: Node in get_children():
		n.queue_free()


func Activate(st: Strategy):
	Clear()
	show()
	
	# for personnel groupings in strategy.???
	for op: OffensePersonnel in st.GetOffensePersonnels():
		var b = Button.new()
		b.text = "%d%d" % [op.rbs, op.tes]
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(b)
		b.pressed.connect(_on_button_pressed.bind(op))


func _on_button_pressed(op: OffensePersonnel):
	personnel_selected.emit(op)
