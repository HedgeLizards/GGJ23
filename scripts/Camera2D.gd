extends Camera2D

func _ready():
	get_viewport().connect('size_changed', self, 'fit_to_viewport')
	
	fit_to_viewport()

func fit_to_viewport():
	zoom.x = 2048 / OS.window_size.x
	zoom.y = zoom.x

func _physics_process(_delta):
	var min_player_y = INF
	
	for player in $'../Players'.get_children():
		var tip = player.get_child(player.get_child_count() - 1).get_node('Tip')
		
		min_player_y = min(min_player_y, tip.global_position.y)
	
	if min_player_y < INF:
		position.y = min(position.y, min_player_y - OS.window_size.y / 4 * zoom.y)
