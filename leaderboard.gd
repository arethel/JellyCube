extends Control

onready var leaders = $leaders.get_children()

func _ready():
	if Auth.leaderboard:
		set_leaders(Auth.leaderboard)

func set_leaders(leaderboard):
	for pl_idx in range(leaderboard.size()):
		leaders[pl_idx].get_node('name').text=leaderboard[pl_idx].doc_fields['name']
		leaders[pl_idx].get_node('score').text=str(leaderboard[pl_idx].doc_fields['maxheight'])


func _on_leaderboard_back_button_pressed():
	Transition.hide_node(self, 1)
