extends Node

func _ready() -> void:
	$MarginContainer/VBoxContainer/Button1.connect("pressed", self, "_on_identify_pressed")
	$MarginContainer/VBoxContainer/Button2.connect("pressed", self, "_on_change_name_pressed")
	$MarginContainer/VBoxContainer/Button3.connect("pressed", self, "_on_track_pressed")
	$MarginContainer/VBoxContainer/Button4.connect("pressed", self, "_on_flush_pressed")
	Talo.events.connect("events_updated", self, "events_updated")
	$MarginContainer/VBoxContainer/LineEditUserName.text = Talo.players.generate_identifier()

func _on_identify_pressed():
	Talo.players.clear_identity()
	if Talo.has_identity():
		prints("player is identified already")
	else:
		prints("player needs to be identified")
		var username = $MarginContainer/VBoxContainer/LineEditUserName.text
		Talo.players.identify("username", username)

func _on_change_name_pressed():
	Talo.players.update({"player_name": $MarginContainer/VBoxContainer/LineEditPlayerName})
	Talo.events.track("change_name", {"player_name": $MarginContainer/VBoxContainer/LineEditPlayerName.text})

func _on_track_pressed():
	Talo.events.track($MarginContainer/VBoxContainer/LineEdit1.text, {"custom_prop": $MarginContainer/VBoxContainer/LineEdit2.text})
	
func _on_flush_pressed():
	Talo.events.flush()
	


func events_updated():
	# this is the signal after submitting connected from a signal instead of a callback
	$MarginContainer/VBoxContainer/Label3.text = "Events in queue: " + str(len(Talo.events._queue))
