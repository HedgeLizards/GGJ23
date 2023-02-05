extends Camera2D

export var shake_intensity = 5

func _ready():
	get_viewport().connect('size_changed', self, 'fit_to_viewport')
	
	fit_to_viewport()

func fit_to_viewport():
	zoom.x = 2048 / OS.window_size.x
	zoom.y = zoom.x

func _physics_process(_delta):
	var min_player_y = INF
	
	var shake = false
	for player in $'../Players'.get_children():
		var germ = player.active_germ()
		var player_y = germ.get_node('Tip').global_position.y
		
		if player_y >= position.y + (OS.window_size.y + 79 / 2) * zoom.y or player_y >= limit_bottom + 79 / 2 * zoom.y:
			germ.die()
		elif player_y < -256 - 1024 * 5 - 256:
			germ.finish()
		
		min_player_y = min(min_player_y, player_y)
		
		if germ.nitro_active:
			shake = true
	
	if shake:
		offset.x = (randf() * 2 - 1) * (shake_intensity)
		offset.y = (randf() * 2 - 1) * (shake_intensity)
	else:
		offset = Vector2.ZERO
	
	if min_player_y < INF:
		position.y = min(position.y, min_player_y - (OS.window_size.y / 3) * zoom.y)
	$'../CanvasLayer/ColorRect'.material.set_shader_param("camera_y", position.y)
