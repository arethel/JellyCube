extends Control


func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_on_login_succeeded")
	Firebase.Auth.connect("auth_request", self, "_on_auth_request")
	Firebase.Auth.connect("login_failed",self, "_on_login_failed")
	
	
	Firebase.Auth.check_auth_file()
	$LogIn.disabled=Firebase.Auth.is_logged_in()
	
#	yield(get_tree().create_timer(6), "timeout")
#	test_update()
	



var gotten_leadearboard
var collection : FirestoreCollection 
#FIRESTORE
func logged_in():#used in _on_auth_request
	var query : FirestoreQuery = FirestoreQuery.new().from("Players").order_by("maxheight", FirestoreQuery.DIRECTION.DESCENDING).limit(10)

	var result : Array = yield(Firebase.Firestore.query(query), "result_query")
	print(result);
	

func test_update():
	var up_task : FirestoreTask = collection.update("Height", {'test2': 'gh Name'})
	var document : FirestoreDocument = yield(up_task, "update_document")
	gotten_leadearboard = document.doc_fields
	print(gotten_leadearboard)


func _on_get_document(document : FirestoreDocument) -> void:
	if(document.doc_fields.name==""):
		$nickname_rect.visible=true
	else:
		$nickname_rect.visible=false



#enter nickname
var nickname_checked = false
func check_nickname():
	if(Firebase.Auth.auth.has('localid') && !nickname_checked):
		nickname_checked=true
		collection = Firebase.Firestore.collection("Players")
		collection.connect("get_document",self,"_on_get_document")
		collection.connect("error", self, "_on_task_error")
		collection.get(Firebase.Auth.auth.localid)

func check_the_same_nickname(nickname):
	var query : FirestoreQuery = FirestoreQuery.new().from("Players").where("name", FirestoreQuery.OPERATOR.EQUAL, nickname).limit(1)
	var result : Array = yield(Firebase.Firestore.query(query), "result_query")
	if(result.size()>0):
		same = true
		return
	same = false

var same = false
func _on_Button_pressed():
	if($nickname_rect/LineEdit.text!=""):
		yield(check_the_same_nickname($nickname_rect/LineEdit.text), "completed")
		if(!same):
			var up_task : FirestoreTask = collection.update(Firebase.Auth.auth.localid, {'name': $nickname_rect/LineEdit.text})
			yield(up_task, "task_finished")
			collection.get(Firebase.Auth.auth.localid)


func _on_cancel_pressed():
	$nickname_rect.visible=false
	_on_LogOut_pressed()

func _on_task_error(code, status, message):
	if(status=="NOT_FOUND"):
		var add_task : FirestoreTask = collection.add(Firebase.Auth.auth.localid, {'maxheight': 0, 'name': ''})
#		var document : FirestoreTask = yield(add_task, "task_finished")
		collection.get(Firebase.Auth.auth.localid)


#LOG IN/OUT
func _on_login_succeeded(user : Dictionary):
	Firebase.Auth.save_auth(Firebase.Auth.auth)
	$LogIn.disabled=Firebase.Auth.is_logged_in()
	check_nickname()

func _on_auth_request(er, mes):
	check_nickname()
#	logged_in()

func _on_login_failed(error, message):
	pass

func _on_LogIn_pressed():
	Firebase.Auth.get_auth_localhost()

func _on_LogOut_pressed():
	Firebase.Auth.logout()
	$LogIn.disabled=Firebase.Auth.is_logged_in()





