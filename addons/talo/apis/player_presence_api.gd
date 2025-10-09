class_name PlayerPresenceAPI extends TaloAPI
## An interface for communicating with the Talo Player Presence API.
##
## This API is used to track and manage player presence in your game. Presence indicates whether players are online
## and their current status.
##
## @tutorial: https://docs.trytalo.com/docs/godot/player-presence

## Emitted when a player's presence status changes.
signal presence_changed(presence, online_changed, custom_status_changed)

func _ready():
	#await Talo.init_completed
	Talo.socket.connect("message_received", self, "_on_message_received")

func _on_message_received(res: String, data: Dictionary) -> void:
	if res == "v1.players.presence.updated":
		emit_signal("presence_changed", TaloPlayerPresence.new(data.presence), data.meta.onlineChanged, data.meta.customStatusChanged)

## Get the presence status for a specific player.
func get_presence(player_id: String):
	client.make_request(HTTPClient.METHOD_GET, "/%s" % player_id, {}, [],false,null)

	#match res.status:
	#	200:
#			return TaloPlayerPresence.new(res.body.presence)
#		_:
#			return null

## Update the presence status for the current player.
func update_presence(online: bool, custom_status =  ""):
	if Talo.identity_check() != OK:
		return null

	client.make_request(HTTPClient.METHOD_PUT, "", {
		online = online,
		customStatus = custom_status
	}, [], false, null)

	#match res.status:
		#200:
			#return TaloPlayerPresence.new(res.body.presence)
		#_:
		#	return null
