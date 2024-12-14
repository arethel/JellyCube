extends Control

export (Gradient) var grad 

var VU_COUNT = 10
const HEIGHT = 200
const FREQ_MAX = 2500.0

const bt_sep = 60

const MIN_DB = 65

const min_height = 65

onready var spectrum = AudioServer.get_bus_effect_instance(1,0)

var play_text

var sticks = []
var glow_stick
func _ready():
	
	
	
	yield(get_tree().create_timer(0.2),"timeout")
	
	play_text=get_tree().get_nodes_in_group("play_txt")[0]
	
	grad = get_tree().get_nodes_in_group('main')[0].grad
	
	glow_stick = load("res://audio spectrum/glow_stick.tscn")
	
#	set_new_screen_size(Transition.get_node('screen_size').rect_size,0)
	last_height.resize(VU_COUNT)
	last_height.fill(0)


var ready = false

func create_sticks():
	for stick in sticks:
		stick.queue_free()
	sticks=[]
	if !glow_stick: return false
	for j in range(2):
		for i in range(VU_COUNT*2):
			var stick = glow_stick.instance()
			stick.region_rect.size.y = min_height
			stick.global_rotation=-PI/2+PI*j
			stick.position = Vector2(rect_size.x/2,
			i*((rect_size.y-bt_sep*2)/(VU_COUNT*2-1))+bt_sep+j*0.5)
			stick.modulate = grad.interpolate((float(i)+1.0)/(float(VU_COUNT)*2.0+1.0))
			stick.mod = stick.modulate
			add_child(stick)
			sticks.append(stick)
	return true

func set_new_screen_size(screen_size, y_offset):
	yield(get_tree().create_timer(0.2),"timeout")
	ready = false
	var rect_new = screen_size
	
	VU_COUNT = int(floor(rect_new.y/rect_size.y*VU_COUNT))
	last_height.resize(VU_COUNT)
	last_height.fill(0)
	rect_size=rect_new
	rect_position.y=-rect_new.y+480
	
	ready = create_sticks()


var min_dif_height = -1
var last_height =[]

func _process(_delta):
	if !ready: return
	var prev_hz = 0
#	var beat = 0
	var total_energy = 0
	
	for i in range(1,(VU_COUNT+1)):
		var hz = i * FREQ_MAX / VU_COUNT;
		var f = spectrum.get_magnitude_for_frequency_range(prev_hz,hz)
		var energy = clamp((MIN_DB + linear2db(f.length()))/MIN_DB,0,1)
		total_energy+=energy
		var height = energy * HEIGHT+min_height
 
		prev_hz = hz
		
		var rects = [
			sticks[VU_COUNT-i],
			sticks[VU_COUNT+i-1],
			sticks[VU_COUNT-i+VU_COUNT*2],
			sticks[VU_COUNT+i-1+VU_COUNT*2]
		]
		
		
#		var tween = get_tree().create_tween()
#		if i==1:
#			if rects[0].region_rect.size.y>height*2:
#				beat+=1
#			elif rects[0].region_rect.size.y<height*2:
#				beat-=1
		
		var height_dif = abs(height-last_height[i-1])
		if height_dif>min_dif_height:
			for rect in rects:
				var time = 0.05*(1+height_dif/height)
				$stick_anim.interpolate_property(rect, "modulate", rect.modulate, rect.mod*max((height+HEIGHT/1.5)/HEIGHT*1.2,1), time)
				$stick_anim.interpolate_property(rect, "region_rect:size:y", rect.region_rect.size.y, height*2, time)
				if(i==1):
					$stick_anim.interpolate_property(play_text, "rect_scale", play_text.rect_scale, Vector2(1+(height-min_height)/HEIGHT/2, 1+(height-min_height)/HEIGHT/2), time)
				$stick_anim.start()
	#			tween.tween_property(rect, "modulate", rect.mod*max((height+HEIGHT/1.5)/HEIGHT*1.2,1), 0.05)
	#			tween.tween_property(rect, "region_rect:size:y", height*2, 0.05)
			last_height[i-1]=height
		
	if(total_energy>1):
		Transition.get_node('music').allow_glow=true
	else:
		Transition.get_node('music').allow_glow=false
#	if beat>0:
#		Transition.get_node('music').glow_beat()


