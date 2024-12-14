extends TextureButton

func _ready():
	pass

func _on_google_button_pressed():
	if Auth.login==0:
		Firebase.Auth.get_auth_localhost()
	elif(Auth.login==1):
		Transition.uppear_node($"../../account_panel")
