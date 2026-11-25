extends Panel


signal formation_selected(of: OffenseFormation)
signal formation_hovered(of: OffenseFormation)
signal play_hovered(op: OffensePlay)
signal plays_called(op: OffensePlay, dp: DefensePlay)


@export var FORMATION_OPTION_LINE: PackedScene
@export var SELECT_PLAY_BUTTON: PackedScene

var offense_strategy: Strategy
var defense_strategy: Strategy


func Activate(gs: GameSimulator, side: GameSimulator.SIDE):
	show()
	offense_strategy = gs.default_strategy
	defense_strategy = gs.default_strategy
	ActivateFormationSelect(gs, side)


func ActivateFormationSelect(gs: GameSimulator, side: GameSimulator.SIDE):
	$Play.hide()
	$Formation.show()
	$AIDefenseInfo.hide()
	
	for n: Node in $Formation/ScrollBox/VBox.get_children():
		n.queue_free()
	for n: Node in $Play/ScrollBox/GridBox.get_children():
		n.queue_free()
	
	if side == gs.offense:
		RenderOffenseFormations()
	else:  # defense
		RenderDefenseFormations()


func RenderOffenseFormations():
	var st = offense_strategy
	var formations = st.GetOffenseFormations()
	for p: String in formations:
		var line: FormationOptionLine = FORMATION_OPTION_LINE.instantiate()
		$Formation/ScrollBox/VBox.add_child(line)
		var f: Array[Formation] = []
		f.assign(formations[p])
		line.Activate(p, f)
		line.formation_selected.connect(_on_offense_formation_selected)
		line.formation_hovered.connect(_on_offense_formation_hovered)

func RenderDefenseFormations():
	var st = defense_strategy
	var formations = st.GetDefenseFormations()
	for p: String in formations:
		var line: FormationOptionLine = FORMATION_OPTION_LINE.instantiate()
		$Formation/ScrollBox/VBox.add_child(line)
		var f: Array[Formation] = []
		f.assign(formations[p])
		line.Activate(p, f)
		line.formation_selected.connect(_on_defense_formation_selected)

func RenderOffensePlays(f: OffenseFormation):
	$Formation.hide()
	$Play.show()
	#$AIDefenseInfo.show()
	
	var plays = offense_strategy.offense_plays.filter(func(p: Play): return p.formation == f)
	for p: OffensePlay in plays:
		var b: Button = SELECT_PLAY_BUTTON.instantiate()
		$Play/ScrollBox/GridBox.add_child(b)
		b.text = p.name
		b.pressed.connect(_on_offense_play_selected.bind(p))
		b.mouse_entered.connect(_on_offense_play_hovered.bind(p))

func RenderDefensePlays():
	$Formation.hide()
	$Play.show()
	
	var plays = defense_strategy.defense_plays
	for p: DefensePlay in plays:
		var b: Button = SELECT_PLAY_BUTTON.instantiate()
		$Play/ScrollBox/GridBox.add_child(b)
		b.text = p.name
		b.pressed.connect(_on_defense_play_selected.bind(p))


func Conclude(op: OffensePlay, dp: DefensePlay):
	# add AI playcall to user playcall
	if not op:
		op = offense_strategy.offense_plays.pick_random()
	elif not dp:
		dp = defense_strategy.defense_plays.pick_random()
	else:
		assert(false)  # this should never happen
	
	plays_called.emit(op, dp)


func _on_offense_formation_hovered(f: OffenseFormation):
	print("Formation hovered: ", f)
	formation_hovered.emit(f)

func _on_offense_formation_selected(f: OffenseFormation):
	print("Formation selected: ", f)
	formation_selected.emit(f)
	RenderOffensePlays(f)

func _on_defense_formation_selected(f: DefenseFormation):
	print("Formation selected: ", f)
	RenderDefensePlays()

func _on_offense_play_selected(p: OffensePlay):
	print("Play selected: ", p)
	Conclude(p, null)

func _on_offense_play_hovered(p: OffensePlay):
	print("Play hovered: ", p)
	play_hovered.emit(p)

func _on_defense_play_selected(p: DefensePlay):
	print("Play selected: ", p)
	Conclude(null, p)
