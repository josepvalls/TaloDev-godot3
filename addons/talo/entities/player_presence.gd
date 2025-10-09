class_name TaloPlayerPresence extends Object

var online: bool
var custom_status: String
var updated_at: String

func _init(data: Dictionary):
	online = data.online
	custom_status = data.customStatus
	updated_at = data.updatedAt
