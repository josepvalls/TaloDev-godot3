class_name PlayersAPI extends TaloAPI
## An interface for communicating with the Talo Players API.
##
## This API is used to identify players and update player data.
##
## @tutorial: https://docs.trytalo.com/docs/godot/identifying

## Emitted when a player has been identified.
signal identified(player)

## Emitted when identification starts.
signal identification_started()

## Emitted when identification fails.
signal identification_failed()

## Emitted after calling clear_identity().
signal identity_cleared()

func _ready() -> void:
	#Talo.connection_restored.connect(_on_connection_restored)
	pass

func _handle_identify_success(alias, socket_token =  ""):
	Talo.current_player = alias["player"]["id"]
	Talo.current_alias = alias["id"]

## Identify a player using a service (e.g. "username") and identifier (e.g. "bob").
func identify(service: String, identifier: String):
	emit_signal("identification_started")
	client.make_request(HTTPClient.METHOD_GET, "/identify?service=%s&identifier=%s" % [service, identifier], {}, [], false, [funcref(self, "identify_callback")])

func identify_callback(res):
	prints("identify_callback", res.body)
	match res.status:
		200:
			var alias = res.body.alias
			#alias.write_offline_alias()
			_handle_identify_success(alias, res.body.socketToken)
		_:
			emit_signal("identification_failed")
			emit_signal("identified", null)


func update_callback(res):
	match res.status:
		200:			
			var p = TaloPlayer.new()
			p.id = res.body.player
			return p
		_:
			return null

signal find_player_id(player)
## Get a player by their ID.
func find(player_id: String):
	client.make_request(HTTPClient.METHOD_GET, "/%s" % player_id, {}, [], false, funcref(self, "find_callback"))
	
func find_callback(res):
	match res.status:
		200:
			emit_signal("find_player_id", res.body.player)
		_:
			emit_signal("find_player_id", null)

## Generate a mostly-unique identifier.
func generate_identifier() -> String:
	var time_hash := str(TaloTimeUtils.get_timestamp_msec()).sha256_text()
	var size := 12
	var split_start := RandomNumberGenerator.new().randi_range(0, time_hash.length() - size)
	return time_hash.substr(split_start, size)


## Create a new socket token. The Talo socket will use this token to identify the player.
func create_socket_token():
	client.make_request(HTTPClient.METHOD_POST, "/socket-token", {}, [], false, funcref(self, "create_socket_token_callback"))
func create_socket_token_callback(res):
	match res.status:
		200:
			prints("res.body.socketToken", res.body.socketToken)
			#Talo.socket.set_socket_token(res.body.socketToken)
		_:
			pass
			#Talo.socket.set_socket_token("")
