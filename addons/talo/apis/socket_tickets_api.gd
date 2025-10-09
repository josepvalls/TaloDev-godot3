class_name SocketTicketsAPI extends TaloAPI
## An interface for communicating with the Talo Socket Tickets API.
##
## This API is used to create tickets for connecting to the Talo Socket.
##
## @tutorial: https://docs.trytalo.com/docs/godot/socket

## Create a new socket ticket.
func create_ticket(custom_callback):
	var callback = funcref(self, "create_ticket_callback")
	if custom_callback:
		callback = custom_callback
	client.make_request(HTTPClient.METHOD_POST, "", {}, [], false, [callback])

func create_ticket_callback(res):
	match res.status:
		200:
			return res.body.ticket
		_:
			printerr("Failed to get socket ticket")
			return ""
