extends Label

var main

func _ready():
	main=get_tree().get_nodes_in_group('main')[0]
	
	main.connect('record_uploaded',self,'upload_record')
	


func upload_record():
	text = var2str(main.record)
