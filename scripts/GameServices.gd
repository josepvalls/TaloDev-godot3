extends Node

class UserData:
	var user_name: String = ""
	var player_name: String = ""
	var user_secret: String = ""
	var room: String = ""
	var telemetry_opt_out: bool = false
	
	
var user_data: UserData = null

func _ready():
	user_data = UserData.new()

	var config = ConfigFile.new()
	var err = config.load("res://remote_server.cfg")
	if err != OK:
		push_error("Error loading the remote_server.cfg config")
