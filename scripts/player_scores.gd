extends HBoxContainer

const PlayerScore = preload('res://scenes/PlayerScore.tscn')
const CONTROLS = [
	['A, D', 'W'],
	['V, N', 'G'],
	['I, P', '9'],
	['LEFT, RIGHT', 'UP'],
	['GAMEPAD', 'A']
]
const COLORS = [Color('#f0028c'), Color('#8dcb4d'), Color('#7cb8e6'), Color('#df952c')]

func _ready():
	for i in Global.players.size():
		add_player(Global.players[i], Global.occupied_variants[i], i)
	
	Global.initialize_world()

func add_player(id, variant, index):
	var player_score = PlayerScore.instance()
	var controls = player_score.get_node('Controls')
	
	controls.text = 'Steer: %s\nNITROgen: %s' % CONTROLS[min(id, 4)]
	controls.add_color_override('font_color', COLORS[variant])
	
	var score = player_score.get_node('Score')
	
	score.text = str(Global.scores[index])
	score.add_color_override('font_color', COLORS[variant])
	score.add_font_override('font', score.get_font('font').duplicate())
	
	var nitrogen = player_score.get_node('Nitrogen')
	var foreground = nitrogen.get('custom_styles/fg').duplicate()
	
	foreground.texture = foreground.texture.duplicate()
	foreground.texture.gradient = foreground.texture.gradient.duplicate()
	
	var foreground_colors = foreground.texture.gradient.colors
	
	foreground_colors[0] = COLORS[variant]
	foreground.texture.gradient.colors = foreground_colors
	
	var background = nitrogen.get('custom_styles/bg').duplicate()
	
	background.shadow_color = COLORS[variant]
	background.shadow_color.a = 0.5
	
	nitrogen.set('custom_styles/fg', foreground)
	nitrogen.set('custom_styles/bg', background)
	
	nitrogen.get_node('Label').add_color_override('font_color', COLORS[variant])
	nitrogen.get_node('Label').text += str(variant + 1)
	
	add_child(player_score)
	move_child(player_score, index)

func remove_player(index):
	get_child(index).free()

func start():
	for player_score in get_children():
		player_score.add_constant_override('separation', -10)
		
		player_score.get_node('Controls').visible = false
		player_score.get_node('Score').visible = true

func update_score(index, to):
	var score = get_child(index).get_node('Score')
	
	score.text = str(to)
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(score.get_font('font'), 'size', 288, 0.25)
	tween.tween_property(score.get_font('font'), 'size', 64, 0.25)

func update_nitrogen(index, to):
	var nitrogen = get_child(index).get_node('Nitrogen')
	
	nitrogen.value = to
	
	var foreground = nitrogen.get('custom_styles/fg')
	var foreground_colors = foreground.texture.gradient.colors
	
	foreground_colors[1] = COLORS[index] + (Color.white - COLORS[index]) * to
	foreground.texture.gradient.colors = foreground_colors

func update_status(index, to):
	get_child(index).get_node('Nitrogen/Label').text = to
