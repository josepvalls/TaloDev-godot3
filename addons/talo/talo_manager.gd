extends Node

## Emitted when Talo has finished setting up internal dependencies.
signal init_completed()

## Emitted when internet connectivity is lost.
signal connection_lost()

## Emitted when internet connectivity is restored.
signal connection_restored()

var current_alias
var current_player#: TaloPlayer setget _set_current_player, _get_current_player

func _set_current_player(value):
	current_player = value

func _get_current_player():
	return null if not current_alias else current_alias.player

var settings: TaloSettings

var players: PlayersAPI
var player_auth: PlayerAuthAPI
var events: EventsAPI
var leaderboards: LeaderboardsAPI
var health_check: HealthCheckAPI
var socket_tickets: SocketTicketsAPI
var player_presence: PlayerPresenceAPI

var socket: TaloSocket

func _ready() -> void:
	_load_config()
	_load_apis()
	_init_socket()

	get_tree().set_auto_accept_quit(false)
	pause_mode = Node.PAUSE_MODE_PROCESS
	emit_signal("init_completed")

func _init_socket() -> void:
	socket = TaloSocket.new()
	add_child(socket)

	if true:
		socket.open_connection()

func _notification(what: int):
	pass
	
func _load_config() -> void:
	settings = TaloSettings.new()

func _load_apis() -> void:
	players = preload("res://addons/talo/apis/players_api.gd").new()
	players.set_url("/v1/players")
	events = preload("res://addons/talo/apis/events_api.gd").new()
	events.set_url("/v1/events")
	#game_config = preload("res://addons/talo/apis/game_config_api.gd").new("/v1/game-config")
	#stats = preload("res://addons/talo/apis/stats_api.gd").new("/v1/game-stats")
	leaderboards = preload("res://addons/talo/apis/leaderboards_api.gd").new()
	leaderboards.set_url("/v1/leaderboards")
	#saves = preload("res://addons/talo/apis/saves_api.gd").new("/v1/game-saves")
	#feedback = preload("res://addons/talo/apis/feedback_api.gd").new("/v1/game-feedback")
	player_auth = preload("res://addons/talo/apis/player_auth_api.gd").new()
	player_auth.set_url("/v1/players/auth")
	#health_check = preload("res://addons/talo/apis/health_check_api.gd").new("/v1/health-check")
	#player_groups = preload("res://addons/talo/apis/player_groups_api.gd").new("/v1/player-groups")
	#channels = preload("res://addons/talo/apis/channels_api.gd").new("/v1/game-channels")
	socket_tickets = preload("res://addons/talo/apis/socket_tickets_api.gd").new()
	socket_tickets.set_url("/v1/socket-tickets")
	#player_presence = preload("res://addons/talo/apis/player_presence_api.gd").new("/v1/players/presence")

	for api in [
		players,
		player_auth,
		leaderboards,
		#health_check,
		socket_tickets,
		#player_presence
	]:
		add_child(api)

func has_identity() -> bool:
	return current_alias != null

func identity_check(should_error = true):
	if not has_identity():
		if should_error:
			printerr("You need to identify a player using Talo.players.identify() before doing this")
		return ERR_UNAUTHORIZED

	return OK

func is_offline() -> bool:
	return settings.offline_mode

func _do_flush() -> void:
	if identity_check(false) == OK:
		pass
		#events.flush()
