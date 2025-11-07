extends Node
# global Database


var database: SQLite
var slot: String


# create .db file and code connection
func Create(s: String):
	slot = s
	DirAccess.copy_absolute(
		"res://Data/Database/template.db",
		"user://save_data/%s/database.db" % slot
	)
	Open()


func Open(s: String = ""):
	if s:
		slot = s
	assert(slot)
	database = SQLite.new()
	database.path = "user://save_data/%s/database.db" % slot
	database.open_db()


# fill db with data
func Initialize():
	var conferences = load("res://Data/Data/ReferenceData/Conferences.csv").records
	database.insert_rows("Conferences", conferences)
	
	var schools = load("res://Data/Data/ReferenceData/Schools.csv").records
	database.insert_rows("Schools", schools)
	
	var test_query = Query("SELECT * FROM Conferences")
	print("Test Query:")
	print(test_query)
	print("---")


func Query(query: String) -> Array[Dictionary]:
	database.query(query)
	return database.query_result


func GetItem(table: String, id: Variant) -> Dictionary:
	database.query("SELECT * FROM %s WHERE ID = '%s'" % [table, id])
	var result = database.query_result
	assert(len(result) == 1)
	return result[0]


func AddRow(table: String, data: Dictionary):
	var success = database.insert_row(table, data)
	assert(success)

func AddRows(table: String, data: Array[Dictionary]):
	var success = database.insert_rows(table, data)
	assert(success)

func UpdateRow(table: String, id: Variant, dict: Dictionary):
	var success = database.update_rows(
		table,
		"id = '%s'" % id,
		dict
	)
	assert(success)


func GetColumnAsList(table: String, column: String, order_by: String, where: String = "") -> Array:
	if where:  # todo: clean this up to not have the if branch, make order_by optional as well
		database.query("SELECT %s FROM %s WHERE %s ORDER BY %s" % [column, table, where, order_by])
	else:
		database.query("SELECT %s FROM %s ORDER BY %s" % [column, table, order_by])
	var result = database.query_result
	var ret_val = []
	for row in result:
		ret_val.append(row[column])
	return ret_val
