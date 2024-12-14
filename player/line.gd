extends Line2D

export (Gradient) var grad 

var pos :=0.0
var follows:=[]

onready var path :=$Path2D

func _ready():
	for i in range(10):
		var new_follow = PathFollow2D.new()
		path.add_child(new_follow)
		new_follow.unit_offset = 0.02*float(i)
		follows.append(new_follow)
		

func _process(delta):
	clear_points()
	for f in follows:
		f.unit_offset = wrapf(f.unit_offset+delta*0.5, 0, 1)
		add_point(f.global_position)
