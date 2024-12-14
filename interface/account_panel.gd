extends Control

func _ready():
	if Auth.pl_stats:
		$nickname.text = Auth.pl_stats['name']
	get_tree().get_nodes_in_group('main')[0].connect('record_uploaded',self,'upload_record')
	

func upload_record():
	$maxheight.text = 'Max Height: '+str(get_tree().get_nodes_in_group('main')[0].record)

func _on_account_panel_back_pressed():
#	Transition.shadow_node($account_panel_back,true)
	Transition.hide_node(self)


func _on_account_logout_button_pressed():
	Firebase.Auth.logout()
	Auth.login=0
	if get_tree().get_nodes_in_group('main'):
		get_tree().get_nodes_in_group('main')[0].set_record(0)
		Transition.hide_node(self)
