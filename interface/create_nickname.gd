extends Control

func _ready():
	Auth.connect("nickname_status", self, "_on_nickname_status")
	

func _on_nickname_status(status):
	if(!status):
		Transition.uppear_node(self, 1)


func _process(_delta):
	if visible&&!Firebase.Auth.auth.has('email'):
		visible=false


func _on_enter_nickname_button_pressed():
	$alert_nickname.text = ""
	if($nickname_field.text!=""):
		yield(Auth.check_the_same_nickname($nickname_field.text), "completed")
		if(!Auth.same):
			var record = 0
			if get_tree().get_nodes_in_group('main'):
				record = get_tree().get_nodes_in_group('main')[0].record
			var add_task : FirestoreTask = Auth.collection.add(Firebase.Auth.auth.localid, {'maxheight': record, 'name': $nickname_field.text, 'email':Firebase.Auth.auth.email})
#			var document : FirestoreTask = yield(add_task, "task_finished")
			yield(add_task, "task_finished")
			Auth.collection.get(Firebase.Auth.auth.localid)
			Transition.hide_node(self, 1)
		else:
			$alert_nickname.text = "This nickname already exists"
	


func _on_cancel_nickname_button_pressed():
	Firebase.Auth.logout()
	visible=false
