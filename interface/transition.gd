extends CanvasLayer


#func _ready():
#	call_deferred('queue_free')

func _ready():
	load_settings()

var games = 0

func start():
	visible=true
	$AnimationPlayer.play('start')

func just_start():
	visible=true
	$AnimationPlayer.play('start2')


func end():
	$AnimationPlayer.play('end')

signal anim_finished

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("anim_finished")
	if anim_name=='start':
		var _err = get_tree().reload_current_scene()
		
	if anim_name=='end':
		visible=false
	

func hide_node(node, time=1):
	var tween = get_tree().create_tween()
	tween.tween_property(node, "modulate:a", 0.0, time)
	tween.play()
	yield(get_tree().create_timer(time),"timeout")
	node.visible=false


func uppear_node(node, time=1):
	node.modulate = Color(1.0, 1.0, 1.0, 0.0)
	node.visible=true
	var tween = get_tree().create_tween()
	tween.tween_property(node, "modulate:a", 1.0, time)
	tween.play()

func shadow_node(node, on_off):
	var cl_node = node.self_modulate
	if(on_off):
		cl_node.r = cl_node.r/2
		cl_node.g = cl_node.g/2
		cl_node.b = cl_node.b/2
		node.modulate=cl_node
		yield(get_tree().create_timer(1.5),"timeout")
		node.modulate=node.self_modulate
	else:
		node.modulate=node.self_modulate





var settings_data = {}

func save_settings():
	if !get_tree().get_nodes_in_group('settings'): return
	var dir = Directory.new()
	if !dir.dir_exists("user://save/"):
		dir.make_dir("user://save/")
	
	var save_game = File.new()
	save_game.open("user://save/settings.save",File.WRITE)
	
	var save_data = get_tree().get_nodes_in_group('settings')[0].get_settings()
	
	var data_string = var2str(save_data)
	save_game.store_string(data_string)
	save_game.close() 
	settings_data=save_data

func load_settings():
	var save_game = File.new()
	if not save_game.file_exists("user://save/settings.save"):
		return 

	save_game.open("user://save/settings.save",File.READ)
	var data_string = save_game.get_as_text()
	var save_data : Dictionary = str2var(data_string)
	save_game.close()
	settings_data=save_data
	
	if !get_tree().get_nodes_in_group('settings'): return
	get_tree().get_nodes_in_group('settings')[0].load_settings()

var max_volume = 30
var min_volume = -30
func set_volume(volume):
	if volume>0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), (volume/10)*(max_volume-min_volume)+min_volume)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)


func check_tutorial():
	var dir = Directory.new()
	if !dir.dir_exists("user://save/"):
		dir.make_dir("user://save/")
		
	var tutorial = File.new()
	if not tutorial.file_exists("user://save/tutorial.save"):
		tutorial.open("user://save/tutorial.save",File.WRITE)
		var data_string = var2str({'tutorial':true})
		tutorial.store_string(data_string)
		tutorial.close() 
		return true
	else:
		return false
	

