extends RefCounted
class_name SeasonGenerator


const NUM_NONCON_GAMES = 3
const CONF_START = 6


static func GenerateTeams(year: int):
	print("\tGenerating Teams...")
	var schools = School.GetAll()
	
	var teams: Array[Dictionary] = []
	for s: School in schools:
		var row = {
			"ID": s.id + str(year),
			"SchoolID": s.id,
			"Year": year
		}
		teams.append(row)
	
	Database.AddRows("Teams", teams)


static func GenerateSchedules(year: int):
	print("\tGenerating Schedules...")
	var games_noncon = AttemptGenerateNonconSchedule(year)
	while not games_noncon:
		games_noncon = AttemptGenerateNonconSchedule(year)
	
	print("\t\t\tSuccessfully generated %d total nonconference games" % len(games_noncon))
	
	var games_conf: Array[Dictionary] = []
	for conf_id: String in Database.GetColumnAsList("Conferences", "ID", "ID"):
		var games_this_conf: Array[Dictionary] = AttemptGenerateConferenceSchedule(conf_id, year)
		print("\t\t\tSuccessfully generated %d conference games" % len(games_this_conf))
		games_conf += games_this_conf
	
	var games: Array[Dictionary] = games_noncon + games_conf
	Database.AddRows("Games", games)


static func AttemptGenerateNonconSchedule(year: int) -> Array[Dictionary]:
	print("\t\tAttempting to generate nonconference schedules...")
	
	var teams_list = Database.GetColumnAsList("Teams", "ID", "ID")
	var conferences_list = Database.GetColumnAsList("Schools", "ConferenceID", "ID")
	
	var counts = {}
	var conferences = {}
	for t in len(teams_list):
		counts[teams_list[t]] = 0
		conferences[teams_list[t]] = conferences_list[t]
	
	var games_needed = []
	var teams_shuffled = teams_list.duplicate()
	teams_shuffled.shuffle()
	#var i = 0
	for team in teams_shuffled:
		#print("\t\t\t", i, " ", team)
		while counts[team] < NUM_NONCON_GAMES:
			var candidates = []
			for other in teams_list:
				if counts[other] < NUM_NONCON_GAMES and conferences[other] != conferences[team]:
					candidates.append(other)
			#print("\t\t\t\tCandidates:", candidates)
			
			if candidates.is_empty():
				return []
			
			var opp = candidates.pick_random()
			if randf() < 0.5:
				games_needed.append([team, opp])
			else:
				games_needed.append([team, opp])
			
			counts[team] += 1
			counts[opp] += 1
		
		#i += 1
	
	#print("\t\t%d total games needed for %d teams" % [len(games_needed), len(teams_list)])
	
	var num_weeks = CONF_START - 1
	var slots = {}
	for team in teams_list:
		slots[team] = []
		for s in num_weeks:
			slots[team].append(s + 1)
	
	var games: Array[Dictionary] = []
	for game in games_needed:
		var valid_slots = []
		for s in slots[game[0]]:
			if s in slots[game[1]]:
				valid_slots.append(s)
		
		if not valid_slots:
			return []
		
		var slot = valid_slots.pick_random()
		slots[game[0]].erase(slot)
		slots[game[1]].erase(slot)
		
		games.append({
			"Year": year, "Week": slot, "AwayTeamID": game[0], "HomeTeamID": game[1]
		})
	
	return games


static func AttemptGenerateConferenceSchedule(conf_id: String, year: int) -> Array[Dictionary]:
	print("\t\tAttempting to generate conference schedule for " + conf_id)
	var teams: Array[String] = []
	teams.assign(
		Database.Query(
			"""SELECT Teams.ID
				FROM Teams LEFT JOIN Schools
					ON Teams.SchoolID = Schools.ID
				WHERE Year = %d AND ConferenceID = '%s'""" % [year, conf_id]
		).map(func(d): return d["ID"])
	)
	var games: Array[Dictionary] = []
	if len(teams) > 1:
		games = AttemptGenerateConferenceScheduleRR(teams, year)
		while not games:
			games = AttemptGenerateConferenceScheduleRR(teams, year)
	return games


static func AttemptGenerateConferenceScheduleRR(teams: Array[String], year: int) -> Array[Dictionary]:
	print("\t\t\tAttempting to generate RR")
	
	var games_needed = []
	for a in range(len(teams)):
		var team = teams[a]
		for b in range(a + 1, len(teams)):
			var opp = teams[b]
			if randf() < 0.5:
				games_needed.append([team, opp])
			else:
				games_needed.append([team, opp])
	
	print("\t\t\t%d total games needed for %d teams (%d per team)" % [len(games_needed), len(teams), (len(teams) - 1)])
	
	var num_weeks = 1 + Timestamp.PHASE_LENGTH[Timestamp.PHASE.REGULAR_SEASON] - CONF_START
	
	var slots = {}
	for team in teams:
		slots[team] = []
		for w in num_weeks:
			slots[team].append(CONF_START + w)
	
	var games: Array[Dictionary] = []
	for game in games_needed:
		var valid_slots = []
		for w in slots[game[0]]:
			if w in slots[game[1]]:
				valid_slots.append(w)
		
		if not valid_slots:
			return []
		
		var slot = valid_slots.pick_random()
		slots[game[0]].erase(slot)
		slots[game[1]].erase(slot)
		
		games.append({
			"Year": year, "Week": slot, "AwayTeamID": game[0], "HomeTeamID": game[1]
		})
	
	return games
