extends Camera2D

export var shake_intensity = 5



func _ready():
	get_viewport().connect('size_changed', self, 'fit_to_viewport')
	
	fit_to_viewport()

func fit_to_viewport():
	zoom.x = Global.level_width / OS.window_size.x
	zoom.y = zoom.x

func _physics_process(_delta):
	var min_player_y = INF
	
	var shake = false
	for player in $'../Players'.get_children():
		var player_y = player.y_position()
		
		if player_y >= position.y + (OS.window_size.y + 79 / 2) * zoom.y or player_y >= limit_bottom + 79 / 2 * zoom.y:
			player.die()
		elif player_y < -256 - Global.level_height * 5 - 256:
			player.finish()
		
		min_player_y = min(min_player_y, player_y)
		
		if player.is_nitro_active():
			shake = true
	
	if shake:
		offset.x = (randf() * 2 - 1) * (shake_intensity)
		offset.y = (randf() * 2 - 1) * (shake_intensity)
	else:
		offset = Vector2.ZERO
	
	
	for player in $'../Players'.get_children():
		var ydiff = (player.y_position() - min_player_y) / 800.0
		player.set_bonus_gain(ydiff)
	
	if min_player_y < INF:
		position.y = min(position.y, min_player_y - (OS.window_size.y / 3) * zoom.y)
	$'../CanvasLayer/ColorRect'.material.set_shader_param("camera_y", position.y)
	var b = min(( 4000.0 - position.y) / 7000.0, 1.0)
	$'../CanvasModulate'.color = Color(b, b, b)
