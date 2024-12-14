extends Node2D

var pl

var height = 0
var record = 0

signal record_uploaded

export (Gradient) var grad





func _ready():
	
	ads()
	
	set_screen_size(Transition.get_node('screen_size').rect_size,banner_height)
#	set_screen_size(Vector2(540,960),0)
	
	
	create_grad()
	
	Transition.end()
	get_record()
	
	var tween = Transition.get_node('change_pitch_of_song')
	var music = Transition.get_node('music')
	tween.interpolate_property(music, "pitch_scale", music.pitch_scale, 1.0, 1.5)
	tween.start()
	
	if (Transition.check_tutorial()&&get_tree().get_nodes_in_group('tutorial')):
		Transition.uppear_node(get_tree().get_nodes_in_group('tutorial')[0])
	
	

	

func respawn_player():
	pl.respawn()

func set_screen_size(screen_size, bottom_offset):
	
	var offset = (screen_size.y-960)/2
	$box/Camera2D.offset.y=-offset+bottom_offset
	
	for screen_node in get_tree().get_nodes_in_group('screen_size'):
		if screen_node.has_method('set_new_screen_size'):
			screen_node.set_new_screen_size(screen_size-Vector2(0,bottom_offset),bottom_offset)
	
	pass


func create_grad():
	for i in range(grad.get_point_count()):
		var  r_color = [0.0,0.0,0.0]
		var n_cl = randi()%3
		r_color[n_cl]=1.0
		var n_cl2 = randi()%3
		while(n_cl2==n_cl):
			n_cl2 = randi()%3
		r_color[n_cl2]=randf()
		
		grad.set_color(i,Color(r_color[0],r_color[1],r_color[2]))


func save_record(with_firebase=false):
	var dir = Directory.new()
	if !dir.dir_exists("user://save/"):
		dir.make_dir("user://save/")
	
	var save_game = File.new()
	save_game.open("user://save/game_data.save",File.WRITE)
	
	var save_data = {
		'record':record
	}
	
	if height>record:
		save_data['record']=height
		
	var data_string = var2str(save_data)
	save_game.store_string(data_string)
	save_game.close() 
	
	if(with_firebase and Firebase.Auth.is_logged_in()):
		Auth.upload_stats({'maxheight':save_data['record']})
	

func get_record():
	var save_game = File.new()
	if not save_game.file_exists("user://save/game_data.save"):
		return 

	save_game.open("user://save/game_data.save",File.READ)
	var data_string = save_game.get_as_text()
	var save_data : Dictionary = str2var(data_string)
	if save_data.has('record'):
		record=save_data['record']
	save_game.close()
	emit_signal("record_uploaded")

func set_record(rec):
	record=rec
	save_record()
	emit_signal("record_uploaded")


func _on_main_tree_exited():
#	save_record(true)
	pass


func ads():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		
		if(MobileAds.get_is_initialized()&&MobileAds.get_is_banner_loaded()):
			banner_height = MobileAds.get_banner_height_in_pixels()/2.0
		
		if(MobileAds.get_is_initialized()&&MobileAds.get_is_rewarded_loaded()):
			$menu/rect/DeathButtons/ContinueWithAd.modulate=Color(1.0,1.0,1.0,1.0)
		
		MobileAds.connect("initialization_complete", self, "_on_MobileAds_initialization_complete")
		
		#banner
		MobileAds.connect("banner_loaded", self, "_on_MobileAds_banner_loaded")
		MobileAds.connect("banner_destroyed", self, "_on_MobileAds_banner_destroyed")
		MobileAds.connect("banner_failed_to_load", self, "_on_MobileAds_banner_failed_to_load")
		
		#interstitial
		MobileAds.connect("interstitial_loaded", self, "_on_MobileAds_interstitial_loaded")
		MobileAds.connect("interstitial_closed", self, "_on_MobileAds_interstitial_closed")
		MobileAds.connect("interstitial_clicked", self, "_on_MobileAds_interstitial_clicked")
		MobileAds.connect("interstitial_failed_to_load", self, "_on_MobileAds_interstitial_failed_to_load")
		MobileAds.connect("interstitial_opened", self, "_on_MobileAds_interstitial_opened")
		
		#rewarded
		MobileAds.connect("rewarded_ad_loaded", self, "_on_MobileAds_rewarded_ad_loaded")
		MobileAds.connect("rewarded_ad_closed", self, "_on_MobileAds_rewarded_ad_closed")
		MobileAds.connect("rewarded_ad_clicked", self, "_on_MobileAds_rewarded_ad_clicked")
		MobileAds.connect("rewarded_ad_failed_to_load", self, "_on_MobileAds_rewarded_ad_failed_to_load")
		MobileAds.connect("rewarded_ad_failed_to_show", self, "_on_MobileAds_rewarded_ad_failed_to_show")
		MobileAds.connect("rewarded_ad_opened", self, "_on_MobileAds_rewarded_ad_opened")
		
		MobileAds.connect("user_earned_rewarded", self, "_on_MobileAds_user_earned_rewarded")
	

func _on_MobileAds_initialization_complete(status : int, adapter_name : String) -> void:
	if status == MobileAds.AdMobSettings.INITIALIZATION_STATUS.READY:
		MobileAds.load_interstitial()
		MobileAds.load_rewarded()
		MobileAds.load_banner()

#banner
var banner_height = 0
func _on_MobileAds_banner_loaded() -> void:
	MobileAds.show_banner()
	banner_height = MobileAds.get_banner_height_in_pixels()/2.0
	set_screen_size(Transition.get_node('screen_size').rect_size,banner_height)
	
func _on_MobileAds_banner_destroyed() -> void:
	pass
func _on_MobileAds_banner_failed_to_load(error_code):
	pass

#interstitial
func check_interstitial():
	Transition.games+=1
	if(Transition.games>=2):
		if(MobileAds.get_is_initialized()):
			if(MobileAds.get_is_interstitial_loaded()):
				MobileAds.show_interstitial()
			else:
				MobileAds.load_interstitial()

func _on_MobileAds_interstitial_loaded() -> void:
	pass
func _on_MobileAds_interstitial_closed() -> void:
	MobileAds.load_interstitial()
	Transition.games=0
func _on_MobileAds_interstitial_clicked():
	pass
func _on_MobileAds_interstitial_failed_to_load(error_code):
	pass
func _on_MobileAds_interstitial_opened():
	pass

#rewarded
func _on_MobileAds_rewarded_ad_loaded() -> void:
	if !gained_reward:
		$menu/rect/DeathButtons/ContinueWithAd.modulate=Color(1.0,1.0,1.0,1.0)
func _on_MobileAds_rewarded_ad_closed() -> void:
	MobileAds.load_rewarded()
	
func _on_MobileAds_rewarded_ad_clicked():
	pass
func _on_MobileAds_rewarded_ad_failed_to_load(error_code):
	pass
func _on_MobileAds_rewarded_ad_failed_to_show(error_code):
	pass
func _on_MobileAds_rewarded_ad_opened():
	pass

func _on_ContinueWithAd_pressed():
	if(MobileAds.get_is_initialized()&&!gained_reward):
		if(MobileAds.get_is_rewarded_loaded()):
			MobileAds.show_rewarded()
		else:
			MobileAds.load_rewarded()

var gained_reward = false
func _on_MobileAds_user_earned_rewarded(currency : String, amount : int) -> void:
	gained_reward=true
	respawn_player()
	$menu/rect/DeathButtons/ContinueWithAd.modulate=Color(0.43,0.0,0.0,1.0)




