extends Area2D



func _on_objKillZone_body_entered(body):
	if(body.get_parent().has_method('block_spawner')):
		body.get_parent().call_deferred('queue_free')
	else:
		body.call_deferred('queue_free')
