extends Control


func _ready():
	load_settings()

func get_settings():
	return {
		'slider':$music_slider.value
		
	}

func load_settings():
	if !Transition.settings_data: return
	$music_slider.value=Transition.settings_data['slider']

func _on_settings_back_button_pressed():
	Transition.save_settings()
	Transition.hide_node(self)


func _on_music_slider_value_changed(value):
	Transition.set_volume(value)



