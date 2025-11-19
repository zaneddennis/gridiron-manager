extends RefCounted
class_name CharacterGenerator

var rng = RandomNumberGenerator.new()

var last_names: Array[String]
var last_freqs: Array[float]

var first_names: Dictionary[int, Array] = {}  # Array[String]
var first_freqs: Dictionary[int, Array] = {}  # Array[float]


func _init() -> void:
	last_names.assign(Database.GetColumnAsList("LastNames", "Name", "Per100k"))
	last_freqs.assign(Database.GetColumnAsList("LastNames", "Per100k", "Per100k"))


func GenerateCharacter(min_birth: int, max_birth: int) -> Dictionary:
	var birth = randi_range(min_birth, max_birth)
	
	return {
		"First": GenerateFirstName(birth),
		"Last": GenerateLastName(),
		"Birth": birth
	}


func GenerateFirstName(year: int) -> String:
	if not year in first_names:
		first_names[year] = Database.GetColumnAsList("FirstNames", "Name", "Per100k", "Year = %d" % year)
		first_freqs[year] = Database.GetColumnAsList("FirstNames", "Per100k", "Per100k", "Year = %d" % year)
	return first_names[year][rng.rand_weighted(first_freqs[year])]

func GenerateLastName() -> String:
	return last_names[rng.rand_weighted(last_freqs)]
