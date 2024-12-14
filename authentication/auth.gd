extends Node

func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_on_login_succeeded")
	Firebase.Auth.connect("auth_request", self, "_on_auth_request")
	Firebase.Auth.connect("login_failed",self, "_on_login_failed")
	Firebase.Auth.check_auth_file()
	get_leaders()
	


func _on_login_succeeded(user : Dictionary):
	check_nickname()

func _on_auth_request(er, mes):
#	check_nickname()
	check_login()


func _on_login_failed(error, message):
	pass


var collection : FirestoreCollection 


var same = false
func check_the_same_nickname(nickname):
	var query : FirestoreQuery = FirestoreQuery.new().from("Players").where("name", FirestoreQuery.OPERATOR.EQUAL, nickname).limit(1)
	var result : Array = yield(Firebase.Firestore.query(query), "result_query")
	if(result.size()>0):
		same = true
		return
	same = false

var connected_collection = false
func check_nickname():
	if !connected_collection:
		collection = Firebase.Firestore.collection("Players")
		collection.connect("get_document",self,"_on_get_document")
		collection.connect("error", self, "_on_task_error")
		connected_collection = true
	if(Firebase.Auth.auth.has('localid')):
		collection.get(Firebase.Auth.auth.localid, 0)


signal nickname_status(exists) #used in create nickname
var nickname_last_status = ""
func _on_get_document(document : FirestoreDocument) -> void:
#	print(Firebase.Auth.auth.has('email'))
	Firebase.Auth.save_auth(Firebase.Auth.auth)
	load_stats(document.doc_fields)
	login=1

func _on_task_error(code, status, message, task_id):
	if(status=="NOT_FOUND"):
		if(task_id==0):
			create_account()
		elif(task_id==1):
			login=0

var login = -1
func check_login():
	if !connected_collection:
		collection = Firebase.Firestore.collection("Players")
		collection.connect("get_document",self,"_on_get_document")
		collection.connect("error", self, "_on_task_error")
		connected_collection = true
	if(Firebase.Auth.auth.has('localid')):
		collection.get(Firebase.Auth.auth.localid, 1)


func create_account():
	emit_signal("nickname_status", false)

var pl_stats
func load_stats(stats):
	pl_stats=stats
	if get_tree().get_nodes_in_group('account_panel'):
		var acc_panel = get_tree().get_nodes_in_group('account_panel')[0]
		acc_panel.get_node('nickname').text = stats['name']
		acc_panel.get_node('maxheight').text = 'Max Height: '+str(stats['maxheight'])
		if get_tree().get_nodes_in_group('main'):
				get_tree().get_nodes_in_group('main')[0].set_record(stats['maxheight'])

func upload_stats(stats):
	if connected_collection&&Firebase.Auth.auth.has('email'):
		var up_task : FirestoreTask = collection.update(Firebase.Auth.auth.localid, stats)
		var document : FirestoreDocument = yield(up_task, "update_document")


var leaderboard
func get_leaders():
	var query : FirestoreQuery = FirestoreQuery.new().from("Players").where("maxheight", FirestoreQuery.OPERATOR.GREATER_THAN, 100).order_by("maxheight", FirestoreQuery.DIRECTION.DESCENDING).limit(10)
	var result : Array = yield(Firebase.Firestore.query(query), "result_query")
	leaderboard=result
	get_tree().get_nodes_in_group('leaderboard')[0].set_leaders(leaderboard)
