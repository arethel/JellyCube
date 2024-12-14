extends Sprite

func _ready():
	$"../music".connect("beat",self,"beat")
	

func beat(song_position_in_beats):
	
	var modA = modulate.a
	$"../anim_rhythm".interpolate_property(self,'modulate:a',modA,modA*2,0.1)
	$"../anim_rhythm".interpolate_property(self,'modulate:a',modA*2,modA,0.1,
	Tween.TRANS_LINEAR,2,0.1)
	$"../anim_rhythm".start()
	
