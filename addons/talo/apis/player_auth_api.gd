class_name PlayerAuthAPI extends TaloAPI
## An interface for communicating with the Talo Player Auth API.
##
## This API is used to handle player authentication in your game. It provides methods for registering, logging in and managing player accounts.
##
## @tutorial: https://docs.trytalo.com/docs/godot/player-authentication

enum LoginResult {
	OK,
	FAILED,
	VERIFICATION_REQUIRED,
}

## Emitted when Talo.player_auth.start_session() is called and a valid session is found.
signal session_found()

## Emitted when Talo.player_auth.start_session() is called and no valid session is found.
signal session_not_found()

var session_manager = TaloSessionManager.new()
var last_error = null

func _handle_error(res: Dictionary, ret = LoginResult.FAILED):
	if res.body != null and res.body.has("errorCode"):
		last_error = TaloAuthError.new(res.body.errorCode)
	else:
		last_error = TaloAuthError.new("API_ERROR")

	return ret

## Identify the player if they have a valid session.
func start_session() -> void:
	if session_manager.check_for_session():
		emit_signal("session_found")
		Talo.players.identify("talo", session_manager.get_identifier())
	else:
		emit_signal("session_not_found")

## Register a new player account. If verification is enabled, a valid email will be required to verify all logins.
func register(identifier: String, password: String, email =  "", verification_enabled =  false):
	if verification_enabled and email.empty():
		printerr("Email is required when verification is enabled")
		return FAILED

	client.make_request(HTTPClient.METHOD_POST, "/register", {
		identifier = identifier,
		password = password,
		email = email,
		verificationEnabled = verification_enabled
	}, [], false, null)

func register_callback(res):
	match res.status:
		200:
			session_manager.handle_session_created(res.body.alias, res.body.sessionToken, res.body.socketToken)
			return OK
		_:
			return _handle_error(res)

## Log in to an existing player account. If verification is required, a verification code will be sent to the player's email.
func login(identifier: String, password: String):
	client.make_request(HTTPClient.METHOD_POST, "/login", {
		identifier = identifier,
		password = password
	}, [], false, null)

func login_callback(res):
	match res.status:
		200:
			if res.body.has("verificationRequired"):
				session_manager.save_verification_alias_id(res.body.aliasId)
			else:
				session_manager.handle_session_created(res.body.alias, res.body.sessionToken, res.body.socketToken)

			if res.body.has("verificationRequired"):
				return LoginResult.VERIFICATION_REQUIRED
			else:
				return LoginResult.OK
		_:
			return _handle_error(res, LoginResult.FAILED)

## Verify a player account using the verification code sent to the player's email.
func verify(verification_code: String):
	client.make_request(HTTPClient.METHOD_POST, "/verify", {
		aliasId = session_manager.get_verification_alias_id(),
		code = verification_code
	}, [], false, null)

func verify_callback(res):
	match res.status:
		200:
			session_manager.handle_session_created(res.body.alias, res.body.sessionToken, res.body.socketToken)
			return OK
		_:
			return _handle_error(res)

## Log out of the current player account.
func logout() -> void:
	client.make_request(HTTPClient.METHOD_POST, "/logout", {}, [], false, null)
	session_manager.clear_session()
