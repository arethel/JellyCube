extends AudioStreamPlayer

export var bpm := 100
export var measures := 4

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat(position)
signal measure(position)

var songs = []

var credit
var credit_info

func _ready():
	randomize()
	
	
	
	songs = [
		[load("res://map/music/Limit 70.mp3"),103, -15,0,
		'Limit 70',
		"""Limit 70 - Kevin MacLeod (incompetech.com)
		Licensed under Creative Commons: By Attribution 4.0 License
		http://creativecommons.org/licenses/by/4.0/"""],
		
		[load("res://map/music/Cut and Run.mp3"),107, -15,0,
		'Cut and Run',
		"""Cut and Run - Kevin MacLeod (incompetech.com)
		Licensed under Creative Commons: By Attribution 4.0 License
		http://creativecommons.org/licenses/by/4.0/"""],
		
		[load("res://map/music/Cognitive Dissonance.mp3"),120, -15, 50,
		'Cognitive Dissonance',
		"""Cognitive Dissonance - Kevin MacLeod (incompetech.com)
		Licensed under Creative Commons: By Attribution 4.0 License'
		http://creativecommons.org/licenses/by/4.0/"""],
		
		[load("res://map/music/Going Home.mp3"),108, -15, 0,
		'Going Home',
		"""Going Home by MusicbyAden
		https://soundcloud.com/musicbyadenMusic 
		promoted by https://www.chosic.com/free-music/all/
		Creative Commons CC BY-SA 3.0
		https://creativecommons.org/licenses/by-sa/3.0/"""],
		
	]
<<<<<<< Updated upstream
	
	credit=get_tree().get_nodes_in_group('music_credit')[0]
	credit_info=get_tree().get_nodes_in_group('music_credit_info')[0]
=======
	if(get_tree().get_nodes_in_group('music_credit')):
		credit=get_tree().get_nodes_in_group('music_credit')[0]
		credit_info=get_tree().get_nodes_in_group('music_credit_info')[0]
	
	last_song = get_last_song()
	
>>>>>>> Stashed changes
	set_random_song()
	
	yield(get_tree().create_timer(0.2),"timeout")
	
	
	min_glow()

func _on_music_finished():
	set_random_song()

var last_song = -1
func get_last_song():
	var dir = Directory.new()
	if !dir.dir_exists("user://save/"):
		dir.make_dir("user://save/")
		
	var song = File.new()
	if not song.file_exists("user://save/song.save"):
		return -1
	else:
		song.open("user://save/song.save",File.READ)
		var data_string = song.get_as_text()
		var save_data : Dictionary = str2var(data_string)
		song.close()
		return save_data['song']

func save_last_song(n_song):
	var dir = Directory.new()
	if !dir.dir_exists("user://save/"):
		dir.make_dir("user://save/")
	
	var song = File.new()
	song.open("user://save/song.save",File.WRITE)
	
	var save_data = {
		'song':n_song
	}
		
	var data_string = var2str(save_data)
	song.store_string(data_string)
	song.close() 

func set_random_song(tr_time=2):
	var r_song = randi()%songs.size()
#	var r_song = 2
	while last_song==r_song&&songs.size()>1:
		r_song = randi()%songs.size()
	last_song=r_song
<<<<<<< Updated upstream
	
	credit.text=songs[r_song][4]
	credit_info.text=songs[r_song][5]
=======
	save_last_song(last_song)
	if(credit):
		credit.text=songs[r_song][4]
		credit_info.text=songs[r_song][5]
	
>>>>>>> Stashed changes
	$"../song_transition".interpolate_property(self,"volume_db",volume_db,-80,tr_time/2)
	$"../song_transition".start()
	
	yield($"../song_transition","tween_completed")
	playing = false
	$"../song_transition".interpolate_property(self,"volume_db",volume_db,songs[r_song][2],tr_time/2)
	
	set_stream(songs[r_song][0])
	bpm=songs[r_song][1]
	sec_per_beat = 60.0 / bpm
	play_from_beat(songs[r_song][3],0)
	$"../song_transition".start()
	
	
	

func set_credit():
	credit=get_tree().get_nodes_in_group('music_credit')[0]
	credit_info=get_tree().get_nodes_in_group('music_credit_info')[0]
	credit.text=songs[last_song][4]
	credit_info.text=songs[last_song][5]
	


func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()

var allow_glow = false
func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("beat", song_position_in_beats)
		emit_signal("measure", measure)
		last_reported_beat = song_position_in_beats
		measure += 1
		
		if(allow_glow):
			glow_beat()
		

func glow_beat():
	for glow in get_tree().get_nodes_in_group('glow'):
		
		if !glow.get_parent().def_a:
			continue
		
		var modA = glow.get_parent().def_a
		
		$"../anim_rhythm".interpolate_property(glow,'modulate:a'
		,modA/2,modA,0.1)
		$"../anim_rhythm".interpolate_property(glow,'modulate:a'
		,modA,modA/2,0.1,
		Tween.TRANS_LINEAR,2,0.1)
	$"../anim_rhythm".start()

func min_glow():
	for glow in get_tree().get_nodes_in_group('glow'):
		if !glow.get_parent().def_a:
			continue
		var modA = glow.get_parent().def_a
		
		$"../anim_rhythm".interpolate_property(glow,'modulate:a'
		,modA,modA/2,0.1,
		Tween.TRANS_LINEAR,2,0.1)
	$"../anim_rhythm".start()


func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)


func play_from_beat(beat, offset):
	play()
	
	seek(beat * sec_per_beat)
	last_reported_beat=beat
	beats_before_start = offset
	measure = beat % measures


func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()



