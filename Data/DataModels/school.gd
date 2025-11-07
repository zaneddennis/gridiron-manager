extends RefCounted
class_name School


var id: String
var name: String
var mascot: String
var conference: Conference
# TODO: location
var head_coach: Coach

var colors: Array[Color]
var logo: Texture


static func GetAll(order_by: String = ""):
	var ob = "ORDER BY %s" % order_by if order_by else ""
	var dicts = Database.Query("SELECT * FROM Schools %s" % ob)
	return dicts.map(func(d: Dictionary): return School.FromDict(d))


static func GetLogo(school_id: String) -> Texture:
	var im =  Image.load_from_file("user://save_data/%s/Logos/%s.png" % [Database.slot, school_id])
	return ImageTexture.create_from_image(im)


static func FromDB(school_id: String) -> School:
	return FromDict(
		Database.GetItem("Schools", school_id)
	)


static func FromDict(d: Dictionary) -> School:
	var s = School.new()
	
	s.id = d["ID"]
	s.name = d["Name"]
	s.mascot = d["Mascot"]
	s.conference = Conference.FromDB(d["ConferenceID"])
	
	s.head_coach = Coach.FromDB(int(d["HeadCoachID"])) if d["HeadCoachID"] else null
	
	# TODO: rerun color data script so the replace() here is no longer necessary
	s.colors.assign(
		[d["Color1"], d["Color2"], d["Color3"]].map(
			func(c: String): return Color.html(c.replace("x", "#")) if Color.html_is_valid(c.replace("x", "#")) else Color.WHITE
		)
	)
	s.logo = GetLogo(s.id)
	
	return s

func ToDict() -> Dictionary:
	var hci = null
	if head_coach:
		hci = head_coach.id
	
	return {
		"ID": id,
		"Name": name,
		"Mascot": mascot,
		"ConferenceID": conference.id,
		"HeadCoachID": hci,
		
		"Color1": "#" + colors[0].to_html(false),
		"Color2": "#" + colors[1].to_html(false),
		"Color3": "#" + colors[2].to_html(false)
	}


func UpdateDB():
	Database.UpdateRow(
		"Schools",
		id,
		ToDict()
	)
