extends Label

func _process(_delta):
	text = var2str(Engine.get_frames_per_second())
