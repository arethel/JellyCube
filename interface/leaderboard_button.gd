extends TextureButton



func _on_leaderboard_button_pressed():
	Transition.uppear_node($"../../leaderboard", 1)
