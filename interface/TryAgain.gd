extends Button



func _on_TryAgain_pressed():
	Transition.start()
	get_tree().get_nodes_in_group('main')[0].save_record(true)
	get_tree().get_nodes_in_group('main')[0].check_interstitial()
