class_name TaloSettings extends Reference
## Talo's configuration options.
##
## @tutorial: https://docs.trytalo.com/docs/godot/settings-reference

var _config_file: ConfigFile

const SETTINGS_PATH := "res://addons/talo/settings.cfg"
const DEFAULT_API_URL := "https://api.trytalo.com"

const DEV_FEATURE_TAG := "talo_dev"
const LIVE_FEATURE_TAG := "talo_live"

var api_url = "https://api.trytalo.com"
var access_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjcyNSwiYXBpIjp0cnVlLCJpYXQiOjE3NTk2ODQ0MjN9.nrACjV78qTHKkvM4pewVcM4EoV3Q0ksAZZMXfvLCgBQ"
var offline_mode = false

func is_debug_build() -> bool:
	if OS.has_feature(LIVE_FEATURE_TAG):
		return false
	if OS.has_feature(DEV_FEATURE_TAG):
		return true
	return OS.is_debug_build() 
