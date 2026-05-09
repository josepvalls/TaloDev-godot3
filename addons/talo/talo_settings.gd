class_name TaloSettings extends Reference

const SETTINGS_PATH := "res://addons/talo/settings.cfg"
const DEFAULT_API_URL := "https://api.trytalo.com"

const DEV_FEATURE_TAG := "talo_dev"
const LIVE_FEATURE_TAG := "talo_live"

var api_url = DEFAULT_API_URL
var access_key = null
var offline_mode = false
var handle_tree_quit = false

var override_debug_build := false
var override_debug_build_value := false

func is_debug_build() -> bool:
	if override_debug_build:
		return override_debug_build_value
	if OS.has_feature(LIVE_FEATURE_TAG):
		return false
	if OS.has_feature(DEV_FEATURE_TAG):
		return true
	return OS.is_debug_build() 
